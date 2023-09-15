@icon("res://Game/Global/Statemachine/Statemachine.png")
extends Node
class_name Statemachine


var state: State

@export var animation_tree: AnimationTree
@export var puppet: State

## Prints the states it goes to. Useful for debugging if it gets stuck
@export var verbose := false


func _ready() -> void:
	if owner.ghost: return
	
	if !owner.is_controlled():
		if is_instance_valid(puppet):
			switch_to(puppet)
		return
	
	for c in get_children():
		if c is State:
			switch_to(c)
			break



func switch_to(new_state: State, msg := {}) -> void:
	if is_instance_valid(state):
		state.exit()
	
	state = new_state
	state.statemachine = self
	
	if is_instance_valid(state):
		if verbose: print(state.name)
		state.enter(msg)


func _process(delta: float) -> void:
	if is_instance_valid(state):
		state.process(delta)


func _physics_process(delta: float) -> void:
	if is_instance_valid(state):
		state.physics_process(delta)


func _unhandled_input(event: InputEvent) -> void:
	if is_instance_valid(state):
		state.unhandled_input(event)














