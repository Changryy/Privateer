extends Area2D


func _ready() -> void:
	add_to_group(&"ship")


func take_hit(data: Dictionary) -> void:
	owner.health -= data.damage


func get_layer() -> Layer:
	return owner.get_parent() as Layer

func get_address() -> Dictionary:
	return {
		type = &"ship",
		id = owner.id,
		path = owner.get_path_to(self)
	}







