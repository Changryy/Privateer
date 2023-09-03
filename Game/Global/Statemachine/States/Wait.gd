extends AnimationState
class_name Wait

@export var min_wait_time: float = 1
@export var max_wait_time: float = 1
@export var next_state: State

func enter(msg := {}) -> void:
	super(msg)
	await get_tree().create_timer(randf_range(min_wait_time, max_wait_time)).timeout
	switch_to_state(next_state, msg)

