extends Area2D
class_name Gamespace

var id: int = 0

var hitbox := CollisionPolygon2D.new()
var viewport := SubViewport.new()
var sprite := Sprite2D.new()

var spawnpoint: Node
var main_node: Node


func _enter_tree() -> void:
	id = len(World.gamespaces)
	World.gamespaces[id] = self


func _ready() -> void:
	add_child(hitbox)
	add_child(viewport)
	add_child(sprite)
	sprite.texture = viewport.get_texture()


func add(scene: PackedScene, node_name := "") -> void:
	var node := scene.instantiate()
	if node_name: node.name = node_name
	node.set_meta(&"path", scene.resource_path)
	
	viewport.add_child(node)
	
	if node.has_method(&"get_spawnpoint"):
		spawnpoint = node.get_spawnpoint()
	
	if node is Ship:
		main_node = node
	
	if Sync.is_server():
		Relay.added(scene, node_name, self)


