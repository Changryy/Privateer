extends State
class_name AnimationState

@export var animation := &""
var playback: AnimationNodeStateMachinePlayback



func enter(_msg := {}) -> void:
	
	if !is_instance_valid(statemachine):
		return printerr("State %s in %s has no statemachine" % [name, owner.name])
	
	if is_instance_valid(statemachine.animation_tree):
		playback = statemachine.animation_tree.get(&"parameters/playback") as AnimationNodeStateMachinePlayback
		
		if is_instance_valid(playback) and !animation.is_empty():
			playback.travel(animation)

