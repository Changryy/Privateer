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
	print("Connecting")
	
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer


func player_connected(id: int) -> void:
	rpc_id(id, &"connected", VERSION, World.get_data())


@rpc("call_remote", "authority", "reliable")
func connected(server_version: String, world_data: Dictionary) -> void:
	print("Connected")
	if server_version != VERSION:
		peer.close()
		return
	
	await World.load_world(world_data)
	
	rpc_id(1, &"loaded")
	is_connected = true


func get_player_by_id(id: int) -> Player:
	return %Players.get_node_or_null(str(id)) as Player

func player_disconnected(id: int) -> void:
	var player := get_player_by_id(id)
	
	if is_instance_valid(player):
		player.queue_free()


@rpc("call_remote", "any_peer", "reliable")
func loaded() -> void:
	var player := Preloads.player.instantiate()
	player.name = str(multiplayer.get_remote_sender_id())
	player.global_position.y = -100
	%Players.add_child(player)



func singleplayer() -> void:
	var player := Preloads.player.instantiate()
	player.global_position.y = -100
	%Players.add_child(player)


@rpc("any_peer", "call_local", "unreliable_ordered")
func sync_player(position: Vector2, velocity: Vector2) -> void:
	var player := get_player_by_id(multiplayer.get_remote_sender_id())
	
	if is_instance_valid(player):
		player.sync(position, velocity)








