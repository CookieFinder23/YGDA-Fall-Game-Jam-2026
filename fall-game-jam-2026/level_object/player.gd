extends Sprite2D

## radian gain per second
const SPEED = 0.5
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$OrbitingObject.ring_pos += SPEED * delta
	if $OrbitingObject.ring_pos > 2 * PI:
		$OrbitingObject.ring_pos -= 2 * PI
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		$OrbitingObject.ring_num += 1
	elif event.is_action_pressed("down"):
		$OrbitingObject.ring_num -= 1
		
