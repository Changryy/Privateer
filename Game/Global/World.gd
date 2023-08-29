extends Node


var player: Player
var ship: Ship

var spawn_point: Vector2 = Vector2(0, -150)


func get_data() -> Dictionary: return {}


func load_world(_data: Dictionary) -> void:
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Game/World/Main.tscn")





