extends Interactable
class_name Helm


@export var pos: Marker2D

var helming: Player


func can_interact(_player: Player) -> bool:
	return !is_instance_valid(helming)

func interact(player: Player) -> void:
	helming = player
	helming.set_state(^"Helming", {helm = self})


func release() -> void:
	helming = null


func current_layer() -> int:
	var gamespace := owner.get_meta(&"gamespace") as Gamespace
	
	if !is_instance_valid(gamespace):
		assert(false, "Ship must be in a gamespace")
		return 0
	
	var layer := gamespace.get_parent() as Layer
	
	if !is_instance_valid(layer):
		assert(false, "Gamespace must be in a layer")
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
	
	var layer: Layer = World.get_layer(new_layer)
	
	if !is_instance_valid(layer):
		return false
	
	owner.get_meta(&"gamespace").reparent(layer)
	return true

