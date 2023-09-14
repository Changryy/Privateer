extends CharacterBody2D
class_name Player


@export var controller: PlayerController
@export var ghost := false


func _enter_tree() -> void:
	if ghost: return
	if name.is_valid_int(): set_multiplayer_authority(name.to_int())
	position = World.get_spawnpoint()


func _ready() -> void:
	if ghost: return
	World.players[name] = self
	
	if !is_multiplayer_authority(): return
	
	World.player = self



func emit_sync() -> void:
	if is_multiplayer_authority():
		Relay.rpc(&"sync_player", position, velocity, %Sprite.flip_h)


func sync(pos: Vector2, vel: Vector2, flip_h: bool) -> void:
	position = pos
	velocity = vel
	%Sprite.flip_h = flip_h
	%Sprite.offset.x = abs(%Sprite.offset.x) * (-1 if flip_h else 1)


func set_state(state_name: NodePath, msg := {}) -> void:
	if is_instance_valid(controller):
		controller.switch_to(state_name, msg)


func register_interaction(interactable: Interactable) -> void:
	if is_instance_valid(controller):
		controller.interactables.append(interactable)

