extends Node


@rpc("any_peer", "call_remote", "unreliable_ordered")
func sync_player(position: Vector2, velocity: Vector2, flip_h: bool) -> void:
	var player: Player = Sync.get_player_by_id(multiplayer.get_remote_sender_id())
	
	if is_instance_valid(player):
		player.sync(position, velocity, flip_h)




@rpc("any_peer", "call_remote", "unreliable_ordered")
func sync_ship(rotation: float) -> void:
	if is_instance_valid(World.ship):
		World.ship.sync(rotation)



## Called when a node is added to a gamespace and is meant to sync that addition with the clients
func added(node: Node, gamespace: Gamespace) -> void:
	var type := &"Invalid"
	if node.has_method(&"get_type"):
		type = node.get_type()
	
	var data = {
		gamespace = gamespace.id,
		type = type
	}
	
	rpc(&"sync_addition", data)



@rpc("authority", "call_remote", "reliable")
func sync_addition(data: Dictionary) -> void:
	var gamespace := World.get_gamespace(data.gamespace)
	if is_instance_valid(gamespace): gamespace.add_from_data(data)



