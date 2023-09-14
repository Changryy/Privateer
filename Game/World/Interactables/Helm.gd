extends Interactable
class_name Helm


@export var pos: Marker2D

var helming: Player



func interact(player: Player) -> void:
	if is_instance_valid(helming): return
	helming = player
	helming.set_state(^"Helming", {helm = self})


func release() -> void:
	helming = null


