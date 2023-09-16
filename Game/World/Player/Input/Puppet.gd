extends AnimationState

var state := &"default"
var flip_locked := false

func enter(msg := {}) -> void:
	super(msg)
	statemachine.state_changed.connect(state_changed)
	assert(is_instance_valid(playback), "Invalid playback")


func state_changed(new_state: StringName) -> void:
	if !is_instance_valid(playback): breakpoint; return
	if new_state == state: return
	
	match state:
		&"Helming":
			state = new_state
			owner.flip(false, true)
			await RenderingServer.frame_post_draw
			await RenderingServer.frame_post_draw
			flip_locked = false
	
	state = new_state
	
	match state:
		&"Helming":
			flip_locked = true
			playback.travel(state)
			owner.velocity = Vector2.ZERO
			await RenderingServer.frame_post_draw
			owner.flip(false, true)


func physics_process(delta: float) -> void:
	match state:
		&"Movement": movement(delta)



func movement(delta: float) -> void:
	owner.velocity.y += PlayerController.GRAVITY * delta
	
	var walking := false
	
	if !is_zero_approx(owner.velocity.x):
		walking = owner.is_on_floor()
	
	if is_instance_valid(playback):
		playback.travel(&"Walk" if walking else &"Idle")
	
	owner.move_and_slide()
	owner.velocity.y += PlayerController.GRAVITY * delta

















