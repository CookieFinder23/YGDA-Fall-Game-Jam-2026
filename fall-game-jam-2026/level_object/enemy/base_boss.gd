extends Node2D
class_name BaseBoss
@export var health: int = 3
@export var speed: float = 0.5
@export var hitbox: RectangleShape2D

func _ready() -> void:
	$BaseEnemy.health = health
	$BaseEnemy.hitbox = hitbox
	$BaseEnemy/Hitbox/CollisionShape2D.shape = hitbox

func _on_base_enemy_damaged() -> void:
	if $BaseEnemy/OrbitingObject.ring_num == 0:
		$BaseEnemy/OrbitingObject.between_ring_progress += 0.01
	elif $BaseEnemy/OrbitingObject.ring_num == GameState.RING_AMOUNT - 1:
		$BaseEnemy/OrbitingObject.between_ring_progress -= 0.01
	elif randi_range(0, 1):
		$BaseEnemy/OrbitingObject.between_ring_progress += 0.01
	else:
		$BaseEnemy/OrbitingObject.between_ring_progress -= 0.01
