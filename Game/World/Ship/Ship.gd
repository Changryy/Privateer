extends AnimatableBody2D
class_name Ship



var synced := false



func _process(_delta: float) -> void:
	if !is_multiplayer_authority(): return
	Relay.rpc("sync_ship", $"../Node2D/Ship".current_animation_position)



func sync(rot: float) -> void:
	if synced: return
	print("Hello!")
	synced = true
	$"../Node2D/Ship".seek(rot)



func _ready() -> void:
	World.ship = self
	$"../Node2D/Ship".play("Test")
	$"../Polygon2D/Ocean".play("Test")

