extends Node




@rpc("any_peer", "call_remote", "unreliable_ordered")
func sync_player(position: Vector2, velocity: Vector2) -> void:
	var player: Player = Sync.get_player_by_id(multiplayer.get_remote_sender_id())
	
	if is_instance_valid(player):
		player.sync(position, velocity)




@rpc("any_peer", "call_remote", "unreliable_ordered")
func sync_ship(rotation: float) -> void:
	if is_instance_valid(World.ship):
		World.ship.sync(rotation)







