extends Area2D
class_name Interactable



func _ready() -> void:
	collision_layer = 0
	collision_mask = Collision.get_layer("Player")
	monitorable = false
	World.interaction.connect(register_interaction)


func interact(_player: Player) -> void: pass

func can_interact(_player: Player) -> bool: return true

func register_interaction(player: Player) -> void:
	if !is_instance_valid(player): return
	if overlaps_body(player): player.register_interaction(self)







