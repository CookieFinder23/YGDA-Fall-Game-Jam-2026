extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$BossKilled.count = GameState.bosses_killed
	if GameState.boss:
		$BossHealth.visible = true
		$AnimatedSprite2D.visible = true
		var base_enemy = GameState.boss.find_child("BaseEnemy")
		$BossHealth.text = "Boss Health:\n" + str(base_enemy.health)
		$AnimatedSprite2D.animation = GameState.boss.name
	else:
		$BossHealth.visible = false
		$AnimatedSprite2D.visible = false
