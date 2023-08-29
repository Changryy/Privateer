extends Node


var player: Player



func get_data() -> Dictionary: return {}


func load_world(_data: Dictionary) -> void:
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Game/World/Main.tscn")





