extends Node

signal interaction(interacter: Player)
signal loaded

var player: Player
var players := {}

var gamespace := Gamespace.new()
var gamespaces := {0: gamespace}

func get_data() -> Dictionary:
	var data: Array[Dictionary] = []
	
	for space in gamespaces:
		for node in space.get_nodes():
			data.append({
				name = node.name,
				path = node.get_meta(&"path"),
				gamespace = gamespace.id
			})
	
	return {
		gamespaces = data
	}


func load_world(data: Dictionary = {}) -> void:
	get_tree().change_scene_to_file("res://Game/World/Main.tscn")
	add_child(gamespace)
	await get_tree().process_frame
	
	if data.is_empty():
		await create_world()
		return
	
	for node in data.gamespaces:
		if not node.gamespace in gamespaces:
			var space = Gamespace.new()
			add_child(space)
		
		Relay.sync_addition(node.gamespace, node.path, node.name)
	
	await get_tree().process_frame
	loaded.emit()


func create_world() -> void:
	gamespace.add(Sync.space)
	
	await get_tree().process_frame
	loaded.emit()


func get_spawnpoint() -> Vector2:
	if is_instance_valid(gamespace):
		if is_instance_valid(gamespace.spawnpoint):
			return gamespace.spawnpoint.position
	return Gamespace.HALF_SIZE



func get_gamespace(id: int) -> Gamespace:
	return gamespaces.get(id)



func get_position(node: Node2D) -> Vector2:
	var space := node.get_meta(&"gamespace") as Gamespace
	if !is_instance_valid(space): return Vector2.ZERO
	return space.global_position + node.global_position - Gamespace.HALF_SIZE



func _unhandled_input(event: InputEvent) -> void:
	if !gamespace.viewport.is_inside_tree(): return
	gamespace.viewport.push_input(event)

