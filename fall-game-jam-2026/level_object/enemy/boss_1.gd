extends Sprite2D

func _process(_delta: float) -> void:
	GameState.fast_ring = $BaseBoss/BaseEnemy/OrbitingObject.ring_num
