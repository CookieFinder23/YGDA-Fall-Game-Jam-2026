extends Sprite2D
const CENTER = Vector2(480, 270)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for flame in [$Flame, $Flame2]:
		flame.visible = flame.global_position.distance_to(CENTER) > 40
