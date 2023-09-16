extends Area2D
class_name Interactable



func _ready() -> void:
	collision_layer = 0
	collision_mask = Collision.get_layer("Interaction")
	monitorable = false
	World.interaction.connect(register_interaction)
	
	if !is_multiplayer_authority(): rpc_id(1, &"request_sync")


@rpc("reliable", "any_peer", "call_remote")
func request_sync() -> void:
	rpc_id(multiplayer.get_remote_sender_id(), &"sync", get_data())


func register_interaction(player: Player) -> void:
	if !is_instance_valid(player): breakpoint; return
	if !is_instance_valid(player.interaction): breakpoint; return
	if overlaps_area(player.interaction): player.register_interaction(self)




@rpc("reliable", "authority", "call_remote")
func sync(_data := {}) -> void: pass

func get_data() -> Dictionary: return {}

func interact(_player: Player) -> void: pass

func can_interact(_player: Player) -> bool: return true

