extends Node

const VERSION := "0.2.2"
const PORT: int = 8765

var peer := ENetMultiplayerPeer.new()
var players := {}
var is_connected := false


@export var space: PackedScene



func _ready() -> void:
	if "--server" in OS.get_cmdline_args(): start_server()
	elif OS.has_feature("server"): start_server()


func start_server() -> void:
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	await World.load_world(World.get_data())
	is_connected = true

func is_server() -> bool:
	return is_connected and multiplayer.is_server()

## 1. [Client] connects to server
func connect_to() -> void:
	peer.create_client("changry.no", PORT)
	multiplayer.multiplayer_peer = peer

## 2. [Server] receives connection
func player_connected(id: int) -> void:
	rpc_id(id, &"connected", VERSION, World.get_data())

## 3. Server tells [client] theyre connected
@rpc("call_remote", "authority", "reliable")
func connected(server_version: String, world_data: Dictionary) -> void:
	if server_version != VERSION:
		peer.close()
		return
	
	await World.load_world(world_data)
	
	rpc_id(1, &"loaded")
	is_connected = true


## Client tells [server] it has loaded
@rpc("call_remote", "any_peer", "reliable")
func loaded() -> void:
	var player := Preloads.player.instantiate()
	player.name = str(multiplayer.get_remote_sender_id())
	World.gamespace.add(player)



func get_player_by_id(id: int) -> Player:
	return %Players.get_node_or_null(str(id)) as Player

func player_disconnected(id: int) -> void:
	var player := get_player_by_id(id)
	
	if is_instance_valid(player):
		player.queue_free()



func singleplayer() -> void:
	var player := Preloads.player.instantiate()
	World.gamespace.add(player)






