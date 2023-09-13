extends Control


signal starting



func connect_to_server() -> void:
	starting.emit()
	Sync.connect_to_server()



func start() -> void:
	starting.emit()
	Sync.singleplayer()
	get_tree().change_scene_to_file("res://Game/World/Main.tscn")
















