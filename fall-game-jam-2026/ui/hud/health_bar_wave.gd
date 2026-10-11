extends Sprite2D

func _ready() -> void:
	position.x = -360


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += 1
	if(position.x > 360):
		position.x = -360
