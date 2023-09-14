extends Area2D
class_name Gamespace

var hitbox := CollisionPolygon2D.new()
var viewport := SubViewport.new()
var sprite := Sprite2D.new()
var spawnpoint: Node


func _ready() -> void:
	add_child(hitbox)
	add_child(viewport)
	add_child(sprite)
	sprite.texture = viewport.get_texture()


func add(scene: PackedScene, node_name := "") -> void:
	var node := scene.instantiate()
	if node_name: node.name = node_name
	viewport.add_child(node)
	
	if Sync.is_server():
		Relay.added(scene, node_name, self)


