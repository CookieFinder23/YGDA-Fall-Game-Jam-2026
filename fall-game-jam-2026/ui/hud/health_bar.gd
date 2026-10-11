extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_health(4)
	pass
	
	
func set_heath(health: int):
	if health > 5:
		health = 5
	if health < 0:
		health = 0
	if health == 5:
		$HealthBarWaveAlpha/HealthBarWave.position.y = 0
	elif health == 0:
		$HealthBarWaveAlpha/HealthBarWave.position.y = 600
	else:
		$HealthBarWaveAlpha/HealthBarWave.position.y = health * 63 + 90
	
