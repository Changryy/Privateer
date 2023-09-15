extends Interactable
class_name Helm


@export var pos: Marker2D
@export var drop_pos: Marker2D

var helming: Player


func can_interact(_player: Player) -> bool:
	return !is_instance_valid(helming)

func interact(player: Player) -> void:
	helming = player
	if is_instance_valid(pos):
		helming.global_position = owner.to_local(pos.global_position)
	helming.set_state(^"Helming", {helm = self})



func release() -> void:
	if is_instance_valid(drop_pos):
		helming.global_position = owner.to_local(drop_pos.global_position)
	helming = null


func current_layer() -> int:
	var layer := owner.get_parent() as Layer
	
	if !is_instance_valid(layer):
		assert(false, "Ship must be in a layer")
		return 0
	
	return layer.id



func move_ship(up := true) -> bool:
	var new_layer := current_layer()
	
	if new_layer == 0:
		return false
	
	new_layer += -1 if up else 1
	
	if up:
		if new_layer < 1:
			return false
	elif new_layer > 3:
		return false
	
	rpc(&"move_to_layer", new_layer)
	return true



@rpc("any_peer", "call_local", "reliable")
func move_to_layer(layer_id: int) -> void:
	var layer: Layer = World.get_layer(layer_id)
	
	if !is_instance_valid(layer):
		assert(false, "Invalid layer %s" % layer_id)
		return
	
	owner.reparent(layer)
	
	for c in owner.contents:
		c.reparent(layer)



