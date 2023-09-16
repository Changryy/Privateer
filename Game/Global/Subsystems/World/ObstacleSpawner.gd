extends Node

@export var obstacles: Array[PackedScene] = []


func _ready() -> void:
	await World.loaded
	await get_tree().process_frame
	if Sync.is_client(): return
	
	spawn_obstacle()
	while is_instance_valid(World.ship):
		await get_tree().create_timer(randf_range(3, 30)).timeout
		spawn_obstacle()


func spawn_obstacle() -> void:
	var layer := World.get_layer(randi_range(1, 3)) as Layer
	assert(is_instance_valid(layer))
	Relay.add(obstacles.pick_random(), layer)
















