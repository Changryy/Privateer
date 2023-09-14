extends AnimationState


var helm: Helm


func enter(msg := {}) -> void:
	super(msg)
	%Sprite.flip_h = false
	helm = msg.helm
	owner.global_position = msg.helm.pos.global_position



func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		helm.release()
		switch_to(^"Movement")










