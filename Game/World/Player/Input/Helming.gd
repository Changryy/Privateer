extends AnimationState







func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		switch_to(^"Movement")










