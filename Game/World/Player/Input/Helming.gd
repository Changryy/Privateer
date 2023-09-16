extends AnimationState


var helm: Helm


func enter(msg := {}) -> void:
	super(msg)
	owner.velocity = Vector2.ZERO
	helm = msg.helm
	await RenderingServer.frame_post_draw
	owner.flip(false)



func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		switch_to(^"Movement")
	elif event.is_action_pressed("helm_up"):
		helm.move_ship(true)
	elif event.is_action_pressed("helm_down"):
		helm.move_ship(false)


func exit() -> void:
	helm.rpc(&"release")
	await RenderingServer.frame_post_draw
	owner.flip(true)










