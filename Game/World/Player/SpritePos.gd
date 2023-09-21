extends Node2D


@export var sync_rotation := true
@export var scalable: Scalable

var last_scale: float = 1



func _process(_delta: float) -> void:
	if owner.ghost: return
	if !is_instance_valid(owner.ship): return
	
	var ship_scale := get_ship_scale()
	
	global_position = owner.ship.to_global(owner.position * ship_scale)
	if sync_rotation: global_rotation = owner.ship.global_rotation
	
	if ship_scale != last_scale:
		last_scale = ship_scale
		if !is_instance_valid(scalable): return
		scalable.set_scale(last_scale)



func get_ship_scale() -> float:
	if !is_instance_valid(owner.ship): return 1
	if !owner.ship.has_meta(&"scalable"): return 1
	var ship_scalable := owner.ship.get_meta(&"scalable") as Scalable
	if !is_instance_valid(ship_scalable): return 1
	return ship_scalable.current_scale





