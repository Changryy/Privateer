extends Node

signal interaction(interacter: Player)


var player: Player
var ship: Ship

var spawnpoint: Node2D


func get_data() -> Dictionary: return {}


func load_world(_data: Dictionary) -> void:
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Game/World/Main.tscn")

func get_spawnpoint() -> Vector2:
	if is_instance_valid(spawnpoint): return spawnpoint.position
	return Vector2.ZERO

func get_gamespace(id: int) -> Gamespace:
	return Gamespace.new()
