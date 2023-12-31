extends AnimationState
class_name PlayerController

const SPEED: float = 1_500
const GRAVITY: float = 5_000
const JUMP_HEIGHT: float = 4_000


var interactables: Array[Interactable] = []

var movable := false

func enter(_msg := {}) -> void:
	super()
	await get_tree().process_frame
	movable = true

func exit() -> void:
	movable = false

func physics_process(delta: float) -> void:
	if !movable: return
	
	owner.velocity.y += GRAVITY * delta
	owner.velocity.x = Input.get_axis(&"left", &"right") * SPEED
	
	var walking := false
	
	if !is_zero_approx(owner.velocity.x):
		walking = owner.is_on_floor()
		if (owner.velocity.x > 0) != %Sprite.flip_h:
			%Sprite.flip_h = owner.velocity.x > 0
			%Sprite.offset.x = abs(%Sprite.offset.x) * -sign(owner.velocity.x)
	
	if is_instance_valid(playback):
		playback.travel(&"Walk" if walking else &"Idle")
	
	owner.move_and_slide()
	owner.emit_sync()
	owner.velocity.y += GRAVITY * delta
	
	if owner.global_position.y > 5_000:
		switch_to(^"Die")



func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"): jump()
	elif event.is_action_pressed("interact"):interact()


func jump():
	if !owner.is_on_floor(): return
	owner.velocity.y = -JUMP_HEIGHT


func interact() -> void:
	interactables.clear()
	World.interaction.emit(owner)
	await get_tree().process_frame
	
	var closest_interactable: Interactable
	var closest_distance: float = INF
	
	for object in interactables:
		if !is_instance_valid(object): continue
		if !object.can_interact(owner): continue
		var distance: float = owner.interaction.global_position.distance_squared_to(object.global_position)
		if distance > closest_distance: continue
		
		closest_distance = distance
		closest_interactable = object
	
	if is_instance_valid(closest_interactable):
		Relay.interact(owner, closest_interactable)



