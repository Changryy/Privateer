extends AnimationState
class_name PlayerController

const SPEED: float = 1_500
const GRAVITY: float = 5_000
const JUMP_HEIGHT: float = 4_000


var interactables: Array[Interactable] = []



func physics_process(delta: float) -> void:
	owner.velocity.y += GRAVITY * delta
	owner.velocity.x = Input.get_axis(&"left", &"right") * SPEED
	
	var walking := false
	
	if !is_zero_approx(owner.velocity.x):
		walking = owner.is_on_floor()
		if (owner.velocity.x > 0) != %Sprite.flip_h:
			%Sprite.flip_h = owner.velocity.x > 0
			%Sprite.offset.x = abs(%Sprite.offset.x) * -sign(owner.velocity.x)
	
	if is_instance_valid(playback):
		if walking:
			playback.travel(&"Walk")
		else:
			playback.travel(&"Idle")
	
	owner.move_and_slide()
	owner.emit_sync()
	owner.velocity.y += GRAVITY * delta
	
	if owner.position.y > 5_000:
		switch_to(^"Die")



func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"): jump()
	if event.is_action_pressed("interact"): interact()


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
		var distance: float = owner.global_position.distance_squared_to(object.global_position)
		if distance > closest_distance: continue
		
		closest_distance = distance
		closest_interactable = object
	
	if is_instance_valid(closest_interactable):
		closest_interactable.interact(owner)



