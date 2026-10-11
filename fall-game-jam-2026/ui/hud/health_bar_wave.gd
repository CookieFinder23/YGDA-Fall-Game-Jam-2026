extends Sprite2D

var target_y: float = 0

func _ready() -> void:
	position.x = -360


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += 2
	if(position.x > 360):
		position.x = -360
	position.y = lerp(position.y, target_y, 1 - pow(0.01, delta))
