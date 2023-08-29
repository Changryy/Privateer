extends AnimatableBody2D
class_name Ship



var rotation_delta: float = 0
var synced := false


func _process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	rotation_delta = fmod(rotation_delta + delta, 1.5)
	Relay.rpc("sync_ship", rotation_delta)



func sync(rot: float) -> void:
	if synced: return
	synced = true
	rotation_delta = rot
	$"../Node2D/Ship".seek(rot)



func _ready() -> void:
	$"../Node2D/Ship".play("Test")
	$"../Polygon2D/Ocean".play("Test")

