@icon("res://Game/Global/Statemachine/Statemachine.png")
extends Node
class_name Statemachine

signal state_changed(state_name: StringName)

var state: State

@export var animation_tree: AnimationTree
@export var puppet: State

## Prints the states it goes to. Useful for debugging if it gets stuck
@export var verbose := false


func _ready() -> void:
	await owner.finished_setup
	
	if owner.ghost: return
	
	if !owner.is_controlled():
		if is_instance_valid(puppet):
			switch_to(puppet)
			rpc_id(owner.name.to_int(), &"request_state")
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
		if owner.is_controlled():
			rpc(&"sync_state", state.name)
			owner.emit_sync()
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



@rpc("reliable", "authority", "call_local")
func sync_state(state_name: StringName) -> void:
	state_changed.emit(state_name)



@rpc("reliable", "any_peer", "call_remote")
func request_state() -> void:
	if !is_instance_valid(state): return
	rpc_id(multiplayer.get_remote_sender_id(), &"sync_state", state.name)






