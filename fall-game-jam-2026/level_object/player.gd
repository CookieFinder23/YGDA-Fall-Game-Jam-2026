extends Sprite2D

## radian change per second
const SPEED = 0.5
## 1 = radians increasing, -1 = radians decreasing
var direction = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$OrbitingObject.ring_pos += SPEED * direction * delta
	if $OrbitingObject.ring_pos > 2 * PI:
		$OrbitingObject.ring_pos -= 2 * PI
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		$OrbitingObject.ring_num += 1
	elif event.is_action_pressed("down"):
		$OrbitingObject.ring_num -= 1
		
