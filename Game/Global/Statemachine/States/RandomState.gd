@icon("res://Game/Global/Statemachine/States/Icons/Random.png")
extends State
class_name RandomState


func enter(msg := {}) -> void:
	var states: Array[State] = []
	
	for c in get_children():
		if c is State:
			states.append(c)
	
	if states.is_empty():
		return printerr("Random state picker in %s has no states to choose from" % owner.name)
	
	switch_to_state(states.pick_random(), msg)





