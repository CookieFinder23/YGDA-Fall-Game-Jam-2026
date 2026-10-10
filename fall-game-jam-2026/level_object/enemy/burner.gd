extends Sprite2D

var flame_dir = 1
func _ready() -> void:
	if $BaseEnemy/OrbitingObject.ring_num == 0:
		flame_dir = 1
	elif $BaseEnemy/OrbitingObject.ring_num == GameState.RING_AMOUNT - 1:
		flame_dir = -1
	elif randi_range(0, 1):
		flame_dir = -1
	if flame_dir == 1:
		$Flame.position.y = 112
	else:
		$Flame.position.y = -112
