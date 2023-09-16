extends Control





func _process(_delta: float) -> void:
	if !is_instance_valid(World.ship): return
	%Health.value = World.ship.health











