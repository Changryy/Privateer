extends AnimationState



func physics_process(delta: float) -> void:
	owner.velocity.y += PlayerController.GRAVITY * delta
	
	var walking := false
	
	if !is_zero_approx(owner.velocity.x):
		walking = owner.is_on_floor()
	
	if is_instance_valid(playback):
		if walking:
			playback.travel(&"Walk")
		else:
			playback.travel(&"Idle")
	
	owner.move_and_slide()
	owner.velocity.y += PlayerController.GRAVITY * delta





