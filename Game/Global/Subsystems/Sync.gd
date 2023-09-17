extends Subsystem

enum {
	NONE,
	SINGLEPLAYER,
	MULTIPLAYER
}


const VERSION := "0.2.2"

const IP_ADDRESS := "31.45.49.247"
const PORT: int = 8765


signal player_count_changed


var peer := ENetMultiplayerPeer.new()
var connection := NONE



func _ready() -> void:
	super()
	if "--server" in OS.get_cmdline_args(): start_server()
	elif OS.has_feature("server"): start_server()


func start_server() -> void:
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	await World.load_world()
	connection = MULTIPLAYER

## 1. [Client] connects to server
func connect_to_server() -> void:
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer

## 2. [Server] receives connection
func player_connected(id: int) -> void:
	rpc_id(id, &"connected", VERSION, World.get_data())

## 3. Server tells [client] theyre connected
@rpc("call_remote", "authority", "reliable")
func connected(server_version: String, world_data: Dictionary) -> void:
	if server_version != VERSION:
		return quit()
	
	await World.load_world(world_data)
	
	rpc_id(1, &"loaded")
	connection = MULTIPLAYER


## Client tells [server] it has loaded
@rpc("call_remote", "any_peer", "reliable")
func loaded() -> void:
	World.spawn_player(multiplayer.get_remote_sender_id())
	player_count_changed.emit()


func player_disconnected(id: int) -> void:
	var player := World.get_player(id) as Player
	if !is_instance_valid(player): breakpoint; return
	
	World.players.erase(id)
	player.queue_free()
	player_count_changed.emit()


func singleplayer() -> void:
	await World.load_world()
	World.spawn_player()

func quit() -> void:
	if Sync.is_client(): peer.close()
	connection = NONE
	World.reset()


func is_multiplayer() -> bool: return connection == MULTIPLAYER
func is_singleplayer() -> bool: return connection == SINGLEPLAYER
func is_server() -> bool: return is_multiplayer() and multiplayer.is_server()
func is_client() -> bool: return is_multiplayer() and !multiplayer.is_server()



