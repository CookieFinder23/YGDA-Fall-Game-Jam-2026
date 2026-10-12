extends Node2D

var shake: float = 1.0
var shake2: float = 10.0

func _process(delta: float) -> void:
	set_health(GameState.player.health)
	if GameState.player.health == 1:
		$HealthBarShake.position = Vector2(randf_range(shake * -1, shake), randf_range(shake * -1, shake))
		$HealthBarShake/HealthBarOutline/HealthBarCracks.visible = true
		$HealthBarShake/HealthBarOutline/HealthBarCracks2.visible = false
	elif GameState.player.health < 1:
		$HealthBarShake.position = Vector2(randf_range(shake2 * -1, shake2), randf_range(shake2 * -1, shake2))
		$HealthBarShake/HealthBarOutline/HealthBarCracks.visible = false
		$HealthBarShake/HealthBarOutline/HealthBarCracks2.visible = true
	else:
		$HealthBarShake.position = Vector2(0, 0)
		$HealthBarShake/HealthBarOutline/HealthBarCracks.visible = false
		$HealthBarShake/HealthBarOutline/HealthBarCracks2.visible = false

func set_health(health: int):
	if health > 5:
		health = 5
	if health < 0:
		health = 0
	if health == 5:
		$HealthBarShake/HealthBarWaveAlpha/HealthBarWave.target_y = 80
	elif health == 0:
		$HealthBarShake/HealthBarWaveAlpha/HealthBarWave.target_y = 600
	else:
		$HealthBarShake/HealthBarWaveAlpha/HealthBarWave.target_y = 430 - health * 68
	
