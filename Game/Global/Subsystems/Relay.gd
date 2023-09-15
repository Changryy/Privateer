extends Node


@rpc("any_peer", "call_remote", "unreliable_ordered")
func sync_player(position: Vector2, velocity: Vector2, flip_h: bool) -> void:
	var player: Player = World.get_player(multiplayer.get_remote_sender_id())
	
	if is_instance_valid(player):
		player.sync(position, velocity, flip_h)




@rpc("any_peer", "call_remote", "unreliable_ordered")
func sync_ship(rotation: float) -> void:
	if is_instance_valid(World.ship):
		World.ship.sync(rotation)



## Called when a node is added to a gamespace and is meant to sync that addition with the clients
func added(scene: PackedScene, node_name: String, gamespace: Gamespace) -> void:
	rpc(&"sync_addition", gamespace.id, scene.resource_path, node_name)



@rpc("authority", "call_remote", "reliable")
func sync_addition(gamespace_id: int, scene_path: String, node_name: String) -> void:
	var gamespace := World.get_gamespace(gamespace_id) as Gamespace
	if !is_instance_valid(gamespace): breakpoint; return
	
	gamespace.add(load(scene_path), node_name)


func interact(player: Player, interactable: Interactable) -> void:
	if !player.name.is_valid_int():
		assert(false, "Player name invalid: %s" % player.name)
		return
	
	rpc(&"sync_interaction", int(player.name), get_path_to(interactable))


@rpc("any_peer", "reliable", "call_local")
func sync_interaction(player_id: int, interactable_path: NodePath) -> void:
	var player := World.get_player(player_id) as Player
	var interactable := get_node(interactable_path) as Interactable
	
	if !is_instance_valid(player): breakpoint; return
	if !is_instance_valid(interactable): breakpoint; return
	
	interactable.interact(player)


