extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameState.boss:
		$AnimatedSprite2D.modulate.a = move_toward($AnimatedSprite2D.modulate.a, 1.0, delta)
		$UiBossHp.modulate.a = move_toward($UiBossHp.modulate.a, 1.0, delta)
		$BossHealthBar.modulate.a = move_toward($BossHealthBar.modulate.a, 1.0, delta)
		$AnimatedSprite2D.animation = GameState.boss.name
	else:
		$AnimatedSprite2D.modulate.a = move_toward($AnimatedSprite2D.modulate.a, 0.0, delta)
		$UiBossHp.modulate.a = move_toward($UiBossHp.modulate.a, 0.0, delta)
		$BossHealthBar.modulate.a = move_toward($BossHealthBar.modulate.a, 0.0, delta)
