extends Camera2D
class_name PlayerCamera


@export var mouse_follow: float = .2
@export var default_zoom: float = .5
@export var max_zoom: float = .4

var screen_shake_offset := Vector2.ZERO
var static_offset := position


func _ready() -> void:
	await owner.finished_setup
	enabled = owner.is_controlled()
	if enabled: make_current()

func _process(_delta: float) -> void:
	var pos := get_viewport().get_mouse_position() - get_viewport_rect().size / 2.
	
	offset = pos * mouse_follow
	offset += screen_shake_offset
	offset += static_offset
	
	var d := (pos / get_viewport_rect().size).length()
	
	zoom = Vector2.ONE * lerpf(default_zoom, max_zoom, smoothstep(0, 1, d))










