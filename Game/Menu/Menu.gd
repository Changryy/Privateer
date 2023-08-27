extends Control


signal starting



func connect_to_server() -> void:
	starting.emit()
	Sync.connect_to("82.164.168.225")



func start() -> void:
	starting.emit()
















