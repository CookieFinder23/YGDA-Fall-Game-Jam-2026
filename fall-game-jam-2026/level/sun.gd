extends Sprite2D

var timer: int = 0

func _process(delta: float) -> void:
	var zoom = sin(deg_to_rad(timer)) * 0.05 + 1.0 + 0.05
	scale = Vector2(zoom, zoom)
	$PointLight2D.energy = zoom
	timer += 1
	if timer > 360:
		timer = timer % 360
