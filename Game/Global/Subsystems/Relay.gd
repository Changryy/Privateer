extends Node

signal layer_added


@rpc("any_peer", "call_remote", "unreliable_ordered")
func sync_player(position: Vector2, velocity: Vector2, flip_h: bool) -> void:
	var player: Player = World.get_player(multiplayer.get_remote_sender_id())
	
	if is_instance_valid(player):
		player.sync(position, velocity, flip_h)



func interact(player: Player, interactable: Interactable) -> void:
	if !player.name.is_valid_int():
		assert(false, "Player name invalid: %s" % player.name)
		return
	
	rpc(&"sync_interaction", player.name.to_int(), get_path_to(interactable))




@rpc("any_peer", "reliable", "call_local")
func sync_interaction(player_id: int, interactable_path: NodePath) -> void:
	var player := World.get_player(player_id) as Player
	var interactable := get_node(interactable_path) as Interactable
	
	if !is_instance_valid(player): breakpoint; return
	if !is_instance_valid(interactable): breakpoint; return
	
	interactable.interact(player)




func add(scene: PackedScene, layer: Layer, node_name: String = "") -> void:
	if Sync.is_multiplayer and !is_multiplayer_authority(): breakpoint; return
	rpc(&"add_scene", scene.resource_path, node_name, layer.id)


@rpc("reliable", "call_local", "authority")
func add_scene(scene_path: String, node_name: String, layer_id: int) -> void:
	var node: Node = load(scene_path).instantiate()
	node.set_meta(&"path", scene_path)
	if node_name: node.name = node_name
	
	var layer := World.get_layer(layer_id) as Layer
	if is_instance_valid(layer): layer.add_child(node)






