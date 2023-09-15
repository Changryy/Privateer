extends Node2D



func _process(_delta: float) -> void:
	if owner.ghost: return
	if !is_instance_valid(owner.ship): breakpoint; return
	global_position = owner.ship.to_global(owner.position)
	global_rotation = owner.ship.global_rotation





