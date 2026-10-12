extends Sprite2D
const ELECTRICITY_BALL = preload("uid://bnpvoj5h7k6k1")
var spawned = false
func _physics_process(_delta: float) -> void:
	if not spawned and $BaseBoss/BaseEnemy.spawn_progress == 1.0:
		spawned = true
		var ball = ELECTRICITY_BALL.instantiate()
		ball.boss = self
		ball.rad_offset = -1 if randf_range(0, 1) else 1
		add_sibling(ball)
