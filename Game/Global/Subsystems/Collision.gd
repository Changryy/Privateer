extends Node


var layers := {}

func _ready() -> void:
	for i in 32:
		var layer_name: String = ProjectSettings.get_setting("layer_names/2d_physics/layer_%s" % (i + 1))
		if !layer_name: continue
		layers[layer_name] = pow(2, i)


func get_layer(layer_name: String) -> int:
	assert(layer_name in layers, "Layer '%s' does not exist" % layer_name)
	return layers.get(layer_name, 0)




