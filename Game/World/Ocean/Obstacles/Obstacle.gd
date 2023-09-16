extends Area2D
class_name Obstacle

@export var damage: float = 50

var damaged: Array[Area2D] = []

func _enter_tree() -> void:
	position.x = 20_000
	position.y = -get_parent().height

func _ready() -> void:
	collision_layer = 0
	collision_mask = Collision.get_layer("Damagable")
	z_index = 11
	if !is_multiplayer_authority(): return
	area_entered.connect(collided)


func _physics_process(delta: float) -> void:
	if !is_instance_valid(World.ship): return
	translate(Vector2.LEFT * World.ship.speed * delta)


func collided(area: Area2D) -> void:
	if area in damaged: return
	if !area.is_in_group(&"ship"): return
	if !area.has_method(&"get_layer"): breakpoint; return
	if area.get_layer() != get_parent(): return
	
	damaged.append(area)
	
	Relay.hit(area, {
		damage = damage
	})

