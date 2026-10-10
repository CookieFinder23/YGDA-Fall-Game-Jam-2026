extends Node2D
@export var health: int = 3
@export var speed: float = 0.5

func _ready() -> void:
	$BaseEnemy.health = health

func _on_base_enemy_damaged() -> void:
	if $BaseEnemy/OrbitingObject.ring_num == 0:
		$BaseEnemy/OrbitingObject.ring_num += 1
	elif $BaseEnemy/OrbitingObject.ring_num == GameState.RING_AMOUNT - 1:
		$BaseEnemy/OrbitingObject.ring_num -= 1
	elif randi_range(0, 1):
		$BaseEnemy/OrbitingObject.ring_num += 1
	else:
		$BaseEnemy/OrbitingObject.ring_num -= 1
