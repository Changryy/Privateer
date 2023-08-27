extends Node

const VERSION := "0.1.0"
const PORT: int = 8765

var peer := ENetMultiplayerPeer.new()
var players := {}
var is_connected := false


func _ready() -> void:
	if "--server" in OS.get_cmdline_args(): start_server()
	elif OS.has_feature("server"): start_server()


func start_server() -> void:
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	is_connected = true

func is_server() -> bool:
	return is_connected and multiplayer.is_server()


func connect_to(ip: String) -> void:
	var valid_ip := ip.is_valid_ip_address()
	if ip == "localhost": valid_ip = true
	if ip.match("*?.?*"): valid_ip = true
	if !valid_ip: return
	
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer


func player_connected(id: int) -> void:
	rpc_id(id, &"connected", VERSION, World.get_data())


@rpc("call_remote", "authority", "reliable")
func connected(server_version: String, world_data: Dictionary) -> void:
	if server_version != VERSION:
		peer.close()
		return
	
	await World.load_world(world_data)
	
	rpc_id(1, &"loaded")
	is_connected = true


func player_disconnected(id: int) -> void:
	# Remove player
	print("player disconnected")
	
	pass


@rpc("call_remote", "any_peer", "reliable")
func loaded() -> void:
	print("player loaded")
	pass
	
	# Spawn player



func singleplayer() -> void:
	var player := Preloads.player.instantiate()
	player.global_position.y = -100
	%Players.add_child(player)











