extends CharacterBody2D


const SPEED: float = 600
const GRAVITY: float = 1_500
const JUMP_HEIGHT: float = 1_000



func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	velocity.x = Input.get_axis("left", "right") * SPEED
	move_and_slide()
	velocity.y += GRAVITY * delta





func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"): jump()





func jump():
	if !is_on_floor(): return
	velocity.y = -JUMP_HEIGHT










