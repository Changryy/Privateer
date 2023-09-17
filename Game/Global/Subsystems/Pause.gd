extends Subsystem

signal has_paused(visibility: bool)

var paused := false

func _ready() -> void:
	super()
	await World.loaded
	if Sync.is_server():
		Sync.player_count_changed.connect(player_count_changed)
		if World.players.is_empty() and !paused: pause()
	


func _input(event: InputEvent) -> void:
	if !event.is_action_pressed(&"pause"): return
	
	pause()
	get_viewport().set_input_as_handled()


func pause() -> void:
	paused = !paused
	has_paused.emit(paused)
	
	if Sync.is_multiplayer():
		if len(World.players) > 1: return
		rpc(&"sync_pause", paused)
	
	get_tree().paused = paused


func sync_pause(new_pause: bool) -> void:
	paused = new_pause
	get_tree().paused = paused
	has_paused.emit(paused)


func player_count_changed() -> void:
	if World.players.is_empty():
		if !paused: pause()
	elif paused:
		pause()
		rpc(&"sync_pause", paused)







