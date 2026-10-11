extends Node2D

func set_health(health: int):
	if health > 5:
		health = 5
	if health < 0:
		health = 0
	if health == 5:
		$HealthBarWaveAlpha/HealthBarWave.target_y = 0
	elif health == 0:
		$HealthBarWaveAlpha/HealthBarWave.target_y = 600
	else:
		$HealthBarWaveAlpha/HealthBarWave.target_y = 430 - health * 68
	
