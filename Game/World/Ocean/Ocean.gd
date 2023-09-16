extends Polygon2D


const DEFAULT_SPEED: float = 600



func _ready() -> void:
	await World.loaded
	assert(is_instance_valid(World.ship))
	
	$Ocean.speed_scale = World.ship.speed / DEFAULT_SPEED
	
	$Ocean.play("Test")






