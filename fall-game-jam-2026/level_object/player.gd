extends Sprite2D
var health: int = 3
## radian change per second
const SPEED: float = 1
## 1 = radians increasing, -1 = radians decreasing
var direction: int = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$OrbitingObject.move(SPEED * direction * delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		$OrbitingObject.ring_num += 1
	elif event.is_action_pressed("down"):
		$OrbitingObject.ring_num -= 1
