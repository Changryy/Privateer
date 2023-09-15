extends CanvasLayer
class_name Layer

@export var id: int = 0
@export var default := false
@export var height: int = 0

func _ready() -> void:
	for c in get_children():
		c.position.y = -height
	
	follow_viewport_enabled = true
	assert(!is_instance_valid(World.layers.get(id)), "Layer %s is a duplicate" % id)
	World.layers[id] = self
	
	if !default: return
	
	assert(!is_instance_valid(World.default_layer), "A default layer already exists")
	World.default_layer = self














