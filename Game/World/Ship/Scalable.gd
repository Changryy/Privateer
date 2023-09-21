extends Node
class_name Scalable

@export var start_node: Node2D

var polygons: Array[CollisionPolygon2D] = []
var sprites: Array[Sprite2D] = []

var current_scale: float = 1


func _ready() -> void:
	owner.set_meta(&"scalable", self)



func retreive_nodes(node: Node2D) -> void:
	if !is_instance_valid(node): return
	if node.top_level: return
	
	if node is CollisionPolygon2D:
		polygons.append(node)
	elif node is Sprite2D:
		sprites.append(node)
	
	assert(not node is CollisionShape2D, "Collision shapes are not supported.\n%s" % get_path_to(node))
	
	for c in node.get_children():
		if not node is Node2D: continue
		retreive_nodes(c)


func set_scale(new_scale: float = 1) -> void:
	polygons.clear()
	sprites.clear()
	retreive_nodes(start_node if is_instance_valid(start_node) else owner)
	
	var scale: float = new_scale / current_scale
	current_scale = new_scale
	
	for poly in polygons:
		for i in len(poly.polygon):
			poly.polygon[i] *= scale
	
	for sprite in sprites:
		sprite.scale = Vector2.ONE * new_scale


