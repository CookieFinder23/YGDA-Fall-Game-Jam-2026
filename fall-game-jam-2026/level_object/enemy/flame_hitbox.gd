extends Area2D

func _on_area_entered(_area: Area2D) -> void:
	GameState.player.health -= 1

func _on_timer_timeout() -> void:
	queue_free()

func _on_activate_timeout() -> void:
	$Death.start()
	$CollisionShape2D.disabled = false
