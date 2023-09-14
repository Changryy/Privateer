extends CanvasLayer
class_name Layer

@export var id: int = 0


func _ready() -> void:
	follow_viewport_enabled = true
	
	if id in World.layers:
		printerr("Layer %s is a duplicate" % id)
	
	World.layers[id] = self














