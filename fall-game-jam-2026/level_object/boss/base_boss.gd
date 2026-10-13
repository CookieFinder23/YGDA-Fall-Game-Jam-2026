extends Node2D
class_name BaseBoss
@export var health: int = 10
@export var speed: float = 0.5
@export var hitbox: RectangleShape2D
@export var random_rotate: bool
func _ready() -> void:
	@warning_ignore("integer_division")
	$BaseEnemy.health = health + GameState.bosses_killed / 3
	$BaseEnemy.hitbox = hitbox
	$BaseEnemy.random_rotate = random_rotate
	$BaseEnemy.speed = speed
	$BaseEnemy/Hitbox/CollisionShape2D.shape = hitbox
	GameState.boss = get_parent()

func _physics_process(_delta: float) -> void:
	GameState.boss_cooldown = min(GameState.bosses_killed * 0.5 + 2, 5)

func _on_base_enemy_damaged() -> void:
	if $BaseEnemy.health % (health * 2) == 0 and $BaseEnemy.health != 0:
		GameState.healer_storage += 1
	if $BaseEnemy/OrbitingObject.ring_num == 0:
		$BaseEnemy/OrbitingObject.between_ring_progress += 0.01
	elif $BaseEnemy/OrbitingObject.ring_num == GameState.RING_AMOUNT - 1:
		$BaseEnemy/OrbitingObject.between_ring_progress -= 0.01
	elif randi_range(0, 1):
		$BaseEnemy/OrbitingObject.between_ring_progress += 0.01
	else:
		$BaseEnemy/OrbitingObject.between_ring_progress -= 0.01
