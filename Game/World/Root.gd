extends Node2D





func _ready() -> void:
	$Ocean.play("Test")
	%Ship.play("Test")
	
	await World.loaded
	%ShipMover.remote_path = %ShipMover.get_path_to(World.gamespace)







