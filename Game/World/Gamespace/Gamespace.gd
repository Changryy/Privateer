extends Area2D
class_name Gamespace

const SIZE: int = 32768
const HALF_SIZE := Vector2.ONE * SIZE / 2.

var id: int = -1

var hitbox := CollisionPolygon2D.new()
var viewport := SubViewport.new()
var sprite := Sprite2D.new()

var spawnpoint: Node
var main_node: Node


func _ready() -> void:
	if id >= 0: return
	
	id = len(World.gamespaces)
	World.gamespaces[id] = self
	
	viewport.transparent_bg = true
	viewport.size = Vector2i(SIZE, SIZE)
	viewport.disable_3d = true
	
	add_child(hitbox)
	add_child(viewport)
	add_child(sprite)
	sprite.texture = viewport.get_texture()




func add(scene: PackedScene, node_name := "") -> void:
	var node := scene.instantiate()
	if node_name: node.name = node_name
	node.set_meta(&"path", scene.resource_path)
	node.set_meta(&"gamespace", self)
	node.position = HALF_SIZE
	
	viewport.add_child(node)
	
	if node.has_method(&"get_spawnpoint"):
		spawnpoint = node.get_spawnpoint()
	
	if node is Ship:
		main_node = node
	
	if Sync.is_server():
		Relay.added(scene, node_name, self)



func get_nodes() -> Array[Node]:
	return viewport.get_children()

