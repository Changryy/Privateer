extends AnimationState


var helm: Helm


func enter(msg := {}) -> void:
	super(msg)
	%Sprite.flip_h = false
	%Sprite.offset.x = abs(%Sprite.offset.x)
	helm = msg.helm
	owner.global_position = msg.helm.pos.global_position



func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		switch_to(^"Movement")
	elif event.is_action_pressed("helm_up"):
		helm.move_ship(true)
	elif event.is_action_pressed("helm_down"):
		helm.move_ship(false)


func exit() -> void:
	helm.release()










