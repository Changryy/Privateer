extends Node2D
class_name Ship

var contents: Array[Node2D] = []

var layer_offset: float = 0
var wave_offset: float = 0

func get_spawnpoint() -> Vector2: return Vector2.ZERO


func _enter_tree() -> void:
	await get_tree().process_frame
	if !is_instance_valid(get_parent()): breakpoint; return
	if not get_parent() is Layer: breakpoint; return
	layer_offset = -get_parent().height
	%Ship.play("Test")


func _process(_delta: float) -> void:
	position.y = layer_offset + wave_offset

