extends CharacterBody2D
class_name Player

signal finished_setup

@export var controller: PlayerController
@export var interaction: Area2D

var ship: Ship
var health: float = 100

@onready var ghost := !name.is_valid_int()

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	if !name.is_valid_int(): return
	set_multiplayer_authority(name.to_int())
	
	ship = World.ship
	
	if !is_instance_valid(ship): assert(false, "Invalid ship")
	else:
		ship.get_spawnpoint()
		ship.contents.append(self)
	
	assert(not name.to_int() in World.players, "Player exists")
	World.players[name.to_int()] = self
	
	if !is_multiplayer_authority(): return finished_setup.emit()
	assert(!is_instance_valid(World.player), "Player exists")
	World.player = self
	finished_setup.emit()

func is_controlled() -> bool:
	return World.player == self

func emit_sync() -> void:
	if is_multiplayer_authority():
		Relay.rpc(&"sync_player", position, velocity, %Sprite.flip_h)


func sync(pos: Vector2, vel: Vector2, flip_h: bool) -> void:
	position = pos
	velocity = vel
	flip(flip_h)

func flip(flip_h: bool, force := false) -> void:
	if !force and %Puppet.flip_locked: return
	
	%Sprite.flip_h = flip_h
	%Sprite.offset.x = abs(%Sprite.offset.x) * (-1 if flip_h else 1)

func set_state(state_name: NodePath, msg := {}) -> void:
	if !is_controlled(): return
	if !is_instance_valid(controller): breakpoint; return
	
	controller.switch_to(state_name, msg)


func register_interaction(interactable: Interactable) -> void:
	if !is_controlled(): breakpoint; return
	if !is_instance_valid(controller): breakpoint; return
	
	controller.interactables.append(interactable)

func die() -> void:
	set_state(^"Die")
