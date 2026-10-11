extends Sprite2D
class_name Player

const BOUNCE_SMOOTH = 0.01
var can_collide = true
const MAX_HEALTH = 5
var health: int = 5:
	set(new_health):
		if new_health == health or not $IFrames.is_stopped():
			return
		health = new_health
		SFX.play(SFX.Id.TAKE_DAMAGE)
		$IFrames.start()
## radian change per second
const SPEED: float = 2.0
## 1 = radians increasing, -1 = radians decreasing
var direction: int = 1
var speed_mult: float = 1.5

func _ready() -> void:
	GameState.player = self

func _physics_process(delta: float) -> void:
	var movement = SPEED * speed_mult * direction * delta
	$OrbitingObject.move(movement)
	if not $Hitbox.has_overlapping_areas():
		can_collide = true
	
	# if confused about this line read https://www.rorydriscoll.com/2016/03/07/frame-rate-independent-damping-using-lerp/
	speed_mult = lerp(speed_mult, 1.0, 1 - pow(BOUNCE_SMOOTH, delta))

func _input(event: InputEvent) -> void:
	if $OrbitingObject.between_ring_progress:
		return
	if (event.is_action_pressed("up") or event.is_action_pressed("left") and direction == 1 or event.is_action_pressed("right") and direction == -1) and $OrbitingObject.ring_num < GameState.RING_AMOUNT - 1:
		$OrbitingObject.between_ring_progress += 0.01
		can_collide = true
	elif (event.is_action_pressed("down") or event.is_action_pressed("left") and direction == -1 or event.is_action_pressed("right") and direction == 1) and $OrbitingObject.ring_num > 0:
		$OrbitingObject.between_ring_progress -= 0.01
		can_collide = true
		
