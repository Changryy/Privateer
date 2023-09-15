extends Node

signal interaction(interacter: Player)
signal loaded

@export var default_ship: PackedScene
var default_layer: Layer

var player: Player
var ship: Ship
var players := {}
var layers := {}



func get_data() -> Dictionary:
	var layer_data := {}
	
	for id in layers:
		var data: Array[Array] = []
		
		for c in layers[id].get_children():
			if !c.has_meta(&"path"): continue
			data.append([c.get_meta(&"path"), c.name])
		
		layer_data[id] = data
	
	return {
		layers = layer_data,
		ship = get_path_to(ship)
	}

func load_world(data: Dictionary = {}) -> void:
	get_tree().change_scene_to_file("res://Game/World/Main.tscn")
	await get_tree().process_frame
	
	if data.is_empty():
		await create_world()
		return
	
	for id in data.layers:
		for node in data.layers[id]:
			Relay.add_scene(node[0], node[1], id)
	
	await get_tree().process_frame
	
	ship = get_node_or_null(data.ship) as Ship
	assert(is_instance_valid(ship), "Invalid ship")
	loaded.emit()


func create_world() -> void:
	Relay.add(default_ship, default_layer)
	await get_tree().process_frame
	
	for c in default_layer.get_children():
		if c is Ship:
			ship = c
			break
	
	assert(is_instance_valid(ship), "Invalid ship")
	loaded.emit()


func get_spawnpoint() -> Vector2:
	if is_instance_valid(ship):
		return ship.get_spawnpoint()
	
	breakpoint
	return Vector2.ZERO


func get_layer(id: int) -> Layer:
	assert(id in layers, "World does not have layer %s" % id)
	assert(is_instance_valid(layers[id]), "World has invalid layer")
	return layers.get(id)

func get_player(id: int) -> Player:
	assert(id in players, "World does not have player %s" % id)
	assert(is_instance_valid(players[id]), "World has invalid player")
	return players.get(id)


func spawn_player(id: int = 0) -> void:
	assert(not id in players, "Player %s already exists" % id)
	Relay.add(Preloads.player, default_layer, str(id))
