extends Area2D
class_name Gamespace

enum Nodes {
	player,
	ship
}

var hitbox := CollisionPolygon2D.new()
var viewport := SubViewport.new()
var sprite := Sprite2D.new()


func _ready() -> void:
	add_child(hitbox)
	add_child(viewport)
	add_child(sprite)
	sprite.texture = viewport.get_texture()


func add(node: Node) -> void:
	viewport.add_child(node)
	if Sync.is_connected: Relay.added(node, self)

func create(data: Dictionary) -> void:
	pass



