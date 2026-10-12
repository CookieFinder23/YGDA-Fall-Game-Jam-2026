extends Node2D

func _process(delta: float) -> void:
	if GameState.boss:
		@warning_ignore("integer_division")
		set_health(GameState.boss.find_child("BaseEnemy").health, GameState.boss.find_child("BaseBoss").health + GameState.bosses_killed / 2)
	else:
		set_health(0, 100)

func set_health(health: int, max: int):
	#-840
	#-290
	if health > max:
		health = max
	if health < 0:
		health = 0
	if health == max:
		$Sprite2D2/Node2D/BossHealthBarWave.target_y = -870
	elif health == 0:
		$Sprite2D2/Node2D/BossHealthBarWave.target_y = -280
	else:
		$Sprite2D2/Node2D/BossHealthBarWave.target_y = -290 - health * 550 / max
	
