extends Sprite2D

func _physics_process(_delta: float) -> void:
	GameState.slow_ring = $BaseBoss/BaseEnemy/OrbitingObject.ring_num
