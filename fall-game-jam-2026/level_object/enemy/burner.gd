extends Sprite2D

func _on_area_2d_area_entered(_area: Area2D) -> void:
	GameState.player.health -= 1

func _physics_process(delta: float) -> void:
	$CPUParticles2D.rotation = $BaseEnemy.direction * 0.25
