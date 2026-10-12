extends Sprite2D

var timer: int = 0

func _process(delta: float) -> void:
	var zoom = sin(deg_to_rad(timer)) * 0.05 + 1.0 + 0.05
	print(timer)
	scale = Vector2(zoom, zoom)
	timer += 1
	if timer > 360:
		timer = timer % 360
