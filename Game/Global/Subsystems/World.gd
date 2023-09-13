extends Node

signal interaction(interacter: Player)


var player: Player
var gamespaces := {}
var gamespace := Gamespace.new()

func get_data() -> Dictionary: return {}


func load_world(data: Dictionary) -> void:
	get_tree().change_scene_to_file("res://Game/World/Main.tscn")
	await get_tree().process_frame
	
	if data.is_empty():
		gamespace.add(Sync.space.instantiate())



func get_spawnpoint() -> Vector2:
	if is_instance_valid(gamespace):
		if is_instance_valid(gamespace.spawnpoint):
			return gamespace.spawnpoint.position
	return Vector2.ZERO



func get_gamespace(id: int) -> Gamespace:
	return gamespaces.get(id)
