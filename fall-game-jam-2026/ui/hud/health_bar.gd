extends Node2D

var bob = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_health(bob)
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		bob += 1
	if event.is_action_pressed("down"):
		bob -= 1

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
	
