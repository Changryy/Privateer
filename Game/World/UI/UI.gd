extends Control


func _ready() -> void:
	Pause.has_paused.connect(pause)
	%Menu.popup_hide.connect( func(): if Pause.paused: Pause.pause() )
	%Menu.hide()



func _process(_delta: float) -> void:
	if !is_instance_valid(World.ship): return
	%Health.value = World.ship.health



func pause(paused: bool) -> void:
	if paused:
		%Menu.popup_centered()
		return
	
	%Menu.hide()



func resume_pressed() -> void:
	pause(false)



func main_menu_pressed() -> void:
	pause(false)
	Sync.quit()
	get_tree().change_scene_to_file(ProjectSettings.get_setting("application/run/main_scene"))




