extends Interactable


var helming: Player



func interact(player: Player) -> void:
	if !is_instance_valid(helming): helming = player
	elif player == helming: helming = null
	
	if !is_instance_valid(helming): return
	
	helming.set_state(^"Helming")





