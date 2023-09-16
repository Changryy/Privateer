extends Node2D
class_name Ship

@export var ground: StaticBody2D
@export var height_offset: float = 50

var contents: Array[Node2D] = []

var layer_offset: float = 0
var wave_offset: float = 0
var sinking_offset: float = 0

var speed: float = 600
var health: float = 100
var is_sinking := false
var id := 0

func get_spawnpoint() -> Vector2: return Vector2.ZERO


func _enter_tree() -> void:
	await get_tree().process_frame
	if !is_instance_valid(get_parent()): breakpoint; return
	if not get_parent() is Layer: breakpoint; return
	layer_offset = -get_parent().height
	%Ship.play("Test")

func _ready() -> void:
	ground.set_process(false)
	World.entered_ship.connect(entered_ship)
	
	id = len(World.ships)
	name = &"ship_%s" % id
	World.ships[id] = self


func _process(_delta: float) -> void:
	position.y = layer_offset + wave_offset - height_offset + sinking_offset
	if is_multiplayer_authority() and health <= 0: rpc(&"sink")

func entered_ship(ship: Ship) -> void:
	ground.set_process(ship == self)

@rpc("reliable", "call_local", "authority")
func sink() -> void:
	if is_sinking: return
	is_sinking = true
	health = 0
	
	var tween := create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_property(self, ^"sinking_offset", 4_000, 8)
	await tween.finished
	
	for c in contents:
		if !is_instance_valid(c): continue
		if c.has_method(&"die"):
			c.die()
	











