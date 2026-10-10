extends Sprite2D
class_name Player

const BOUNCE_SMOOTH = 0.01
var can_collide = true
var health: int = 5:
	set(new_health):
		if new_health == health or not $IFrames.is_stopped():
			return
		health = new_health
		$IFrames.start()
## radian change per second
const SPEED: float = 2.0
## 1 = radians increasing, -1 = radians decreasing
var direction: int = 1
var speed_mult: float = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var movement = SPEED * speed_mult * direction * delta
	$OrbitingObject.move(movement)
	if not $Hitbox.has_overlapping_areas():
		can_collide = true
	
	# if confused about this line read https://www.rorydriscoll.com/2016/03/07/frame-rate-independent-damping-using-lerp/
	speed_mult = lerp(speed_mult, 1.0, 1 - pow(BOUNCE_SMOOTH, delta))

func _input(event: InputEvent) -> void:
	var old_ring_num = $OrbitingObject.ring_num
	if event.is_action_pressed("up"):
		$OrbitingObject.ring_num += 1
	elif event.is_action_pressed("down"):
		$OrbitingObject.ring_num -= 1
	if old_ring_num != $OrbitingObject.ring_num:
		can_collide = true
