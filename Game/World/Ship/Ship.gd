extends AnimatableBody2D
class_name Ship


@export var animation: AnimationPlayer


func _process(_delta: float) -> void:
	if !is_multiplayer_authority(): return
#	Relay.rpc("sync_ship", animation.current_animation_position)



var last_sync: int = 0

func sync(seconds: float) -> void:
	if last_sync:
		var time: float = Time.get_ticks_usec() - last_sync
		
		if time < 300_000:
			time /= 1e+6
			time *= animation.speed_scale
			animation.seek(seconds + time)
	
	last_sync = Time.get_ticks_usec()



func _ready() -> void:
	pass
#	animation.play("Test")

