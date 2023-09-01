extends CharacterBody2D
class_name Player


const SPEED: float = 1_500
const GRAVITY: float = 5_000
const JUMP_HEIGHT: float = 4_000


@onready var animation: AnimationNodeStateMachinePlayback = %AnimationTree["parameters/playback"]

var interactables: Array[Interactable] = []
var dead := false


func _enter_tree() -> void:
	if name.is_valid_int(): set_multiplayer_authority(name.to_int())
	global_position = World.get_spawnpoint()


func _ready() -> void:
	if !is_multiplayer_authority(): return
	
	World.player = self
	%Camera.make_current()





func _physics_process(delta: float) -> void:
	if dead: return
	velocity.y += GRAVITY * delta
	
	if is_multiplayer_authority():
		velocity.x = Input.get_axis("left", "right") * SPEED
	
	var walking := false
	
	if velocity.x:
		walking = is_on_floor()
		if (velocity.x > 0) != %Sprite.flip_h:
			%Sprite.flip_h = velocity.x > 0
			%Sprite.offset.x = abs(%Sprite.offset.x) * -sign(velocity.x)
	
	if walking:
		animation.travel("Walk")
	else:
		animation.travel("Idle")
	
	
	move_and_slide()
	
	if is_multiplayer_authority():
		Relay.rpc(&"sync_player", position, velocity)
	
	velocity.y += GRAVITY * delta
	
	
	if position.y > 5_000: die()


func _unhandled_input(event: InputEvent) -> void:
	if !is_multiplayer_authority(): return
	if event.is_action_pressed("jump"): jump()
	if event.is_action_pressed("interact"): interact()


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
	OS.alert("Oopsie woopsie!!!\n*blushes adorably*\n\nYou have dieded vewy much~ UwU\n\nGoodbye adowable ✨fwuffball✨ :333")
	get_tree().quit()


func interact() -> void:
	interactables.clear()
	World.interaction.emit(self)
	await get_tree().process_frame
	
	var closest_interactable: Interactable
	var closest_distance: float = INF
	
	for object in interactables:
		if !is_instance_valid(object): continue
		var distance: float = global_position.distance_squared_to(object.global_position)
		if distance > closest_distance: continue
		
		closest_distance = distance
		closest_interactable = object
	
	if is_instance_valid(closest_interactable):
		closest_interactable.interact(self)


func set_state(_state_name: NodePath) -> void:
	pass


