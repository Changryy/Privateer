extends CharacterBody2D
class_name Player


const SPEED: float = 600
const GRAVITY: float = 1_500
const JUMP_HEIGHT: float = 1_000


var dead := false


func _enter_tree() -> void:
	if name.is_valid_int(): set_multiplayer_authority(name.to_int())
	global_position = World.spawn_point


func _ready() -> void:
	if !is_multiplayer_authority(): return
	
	World.player = self
	%Camera.make_current()





func _physics_process(delta: float) -> void:
	if dead: return
	velocity.y += GRAVITY * delta
	
	if is_multiplayer_authority():
		velocity.x = Input.get_axis("left", "right") * SPEED
	
	move_and_slide()
	
	if is_multiplayer_authority():
		Relay.rpc(&"sync_player", position, velocity)
	
	velocity.y += GRAVITY * delta
	
	
	if position.y > 500: die()


func _unhandled_input(event: InputEvent) -> void:
	if !is_multiplayer_authority(): return
	if event.is_action_pressed("jump"): jump()


func jump():
	if dead: return
	if !is_on_floor(): return
	velocity.y = -JUMP_HEIGHT



func sync(pos: Vector2, vel: Vector2) -> void:
	position = pos
	velocity = vel


func die() -> void:
	dead = true
	if !is_multiplayer_authority(): return
	Sync.peer.close()
	OS.alert("You have dieded")
	get_tree().quit()



