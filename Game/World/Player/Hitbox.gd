extends Area2D


func _ready() -> void:
	add_to_group(&"character")

func take_hit(_data: Dictionary) -> void: pass

func get_layer() -> Layer:
	return owner.get_parent() as Layer

func get_address() -> Dictionary:
	return {
		type = &"player",
		id = owner.name.to_int(),
		path = owner.get_path_to(self)
	}

