extends Node

signal interaction(interacter: Player)
signal loaded

@export var default_space: PackedScene
var default_layer: Layer

var player: Player
var players := {}

var gamespace := Gamespace.new()
var gamespaces := {0: gamespace}

var layers := {}

func get_data() -> Dictionary:
	var data: Array[Dictionary] = []
	
	for space in gamespaces.values():
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
	await get_tree().process_frame
	default_layer.add_child(gamespace)
	await get_tree().process_frame
	
	if data.is_empty():
		await create_world()
		return
	
	for node in data.gamespaces:
		if not node.gamespace in gamespaces:
			var space = Gamespace.new()
			default_layer.add_child(space)
		
		Relay.sync_addition(node.gamespace, node.path, node.name)
	
	await get_tree().process_frame
	loaded.emit()


func create_world() -> void:
	gamespace.add(default_space)
	
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

func get_layer(layer_id: int) -> Layer:
	assert(layer_id in layers, "World does not have layer %s" % layer_id)
	assert(is_instance_valid(layers[layer_id]), "World has invalid layer")
	return layers.get(layer_id)

func get_player(player_id: int) -> Player:
	assert(player_id in players, "World does not have player %s" % player_id)
	assert(is_instance_valid(players[player_id]), "World has invalid player")
	return players.get(player_id)

