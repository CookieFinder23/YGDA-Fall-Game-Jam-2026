extends TextureButton

var zoom: float = 1.0

func _process(delta: float) -> void:
	if is_hovered():
		zoom = 1.1
	else:
		zoom = 1.0
	
	scale.x = lerp(scale.x, zoom, 1 - pow(0.01, delta))
	scale.y = lerp(scale.y, zoom, 1 - pow(0.01, delta))
