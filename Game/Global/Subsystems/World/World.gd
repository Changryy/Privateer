extends Subsystem

signal interaction(interacter: Player)
signal loaded
signal entered_ship(ship: Ship)

@export var default_ship: PackedScene
var default_layer: Layer

var player: Player
var ship: Ship
var players := {}
var layers := {}
var ships := {}


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
	var err := get_tree().change_scene_to_file("res://Game/World/Main.tscn")
	assert(err == OK)
	
	if data.is_empty():
		await get_tree().process_frame
		await create_world()
		return
	
	for _i in len(data.layers):
		await Relay.layer_added
	
	for id in data.layers:
		for node in data.layers[id]:
			Relay.add_scene(node[0], node[1], id)
	
	await get_tree().process_frame
	
	ship = get_node_or_null(data.ship) as Ship
	assert(is_instance_valid(ship), "Invalid ship")
	entered_ship.emit(ship)
	finished_loading()

func finished_loading() -> void:
	await get_tree().process_frame
	loaded.emit()

func create_world() -> void:
	Relay.add(default_ship, default_layer)
	await get_tree().process_frame
	
	for c in default_layer.get_children():
		if c is Ship:
			ship = c
			entered_ship.emit(ship)
			break
	
	assert(is_instance_valid(ship), "Invalid ship")
	finished_loading()


func get_layer(id: int) -> Layer:
	assert(id in layers, "World does not have layer %s" % id)
	assert(is_instance_valid(layers[id]), "World has invalid layer")
	return layers.get(id)

func get_player(id: int) -> Player:
	return players.get(id)

func get_ship(id: int) -> Ship:
	assert(id in ships, "World does not have ship %s" % id)
	assert(is_instance_valid(ships[id]), "World has invalid ship")
	return ships.get(id)

func spawn_player(id: int = 1) -> void:
	assert(not id in players, "Player %s already exists" % id)
	var layer := default_layer
	
	if is_instance_valid(ship):
		layer = ship.get_parent()
	
	Relay.add(Preloads.player, layer, str(id))

func reset() -> void:
	player = null
	ship = null
	players.clear()
	layers.clear()
	ships.clear()


