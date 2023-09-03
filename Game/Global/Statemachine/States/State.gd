extends Node
class_name State



var statemachine: Statemachine



func switch_to(state_name: NodePath, msg := {}) -> void:
	if !is_instance_valid(statemachine):
		return printerr("State %s in %s has no statemachine" % [name, owner.name])
	
	var state := statemachine.get_node_or_null(state_name) as State
	
	if !is_instance_valid(state):
		return printerr("Invalid state %s in %s" % [state_name, owner.name])
	
	statemachine.switch_to(state, msg)


func switch_to_state(state: State, msg := {}) -> void:
	if !is_instance_valid(statemachine):
		return printerr("State %s in %s has no statemachine" % [name, owner.name])
	
	statemachine.switch_to(state, msg)




func enter(_msg := {}) -> void: pass
func exit() -> void: pass



func process(_delta: float) -> void: pass
func physics_process(_delta: float) -> void: pass
func unhandled_input(_event: InputEvent) -> void: pass








