extends AnimatedSprite2D
class_name Player

const BOUNCE_SMOOTH = 0.1
var can_collide = true
var dead = false
const MAX_HEALTH = 5
var health: int = 5:
	set(new_health):
		if new_health == health or not $IFrames.is_stopped():
			return
		if new_health <= 0:
			get_parent().get_parent().screenshake = 15
			SFX.play(SFX.Id.TAKE_DAMAGE)
			dead = true
			health = 0
			play("death")
			$Hitbox/CollisionShape2D.disabled = true
			can_collide = false
			$DeathSoundTiming.start()
			return
		var damaged = new_health < health
		health = new_health
		if damaged and not GameState.tutorial:
			Engine.time_scale = 0.5
			speed_mult = 0.8
			get_parent().get_parent().screenshake = 12
			SFX.play(SFX.Id.TAKE_DAMAGE)
			play("hit")
			$IFrames.start()
		
## radian change per second
const SPEED: float = 2.0
## 1 = radians increasing, -1 = radians decreasing
var direction: int = 1
var speed_mult: float = 1

func _ready() -> void:
	GameState.player = self
	if GameState.tutorial:
		health -= 1
func _physics_process(delta: float) -> void:
	if dead:
		return
	var movement = SPEED * speed_mult * direction * delta
	if $OrbitingObject.ring_num == GameState.slow_ring:
		movement *= 0.5
	$OrbitingObject.move(movement)
	if not $Hitbox.has_overlapping_areas():
		can_collide = true
	
	# if confused about this line read https://www.rorydriscoll.com/2016/03/07/frame-rate-independent-damping-using-lerp/
	speed_mult = lerp(speed_mult, 1.0, 1 - pow(BOUNCE_SMOOTH, delta))

func _input(event: InputEvent) -> void:
	if dead or $OrbitingObject.between_ring_progress:
		return
	if (event.is_action_pressed("up") or event.is_action_pressed("left") and direction == 1 or event.is_action_pressed("right") and direction == -1) and $OrbitingObject.ring_num < GameState.RING_AMOUNT - 1:
		$OrbitingObject.between_ring_progress += 0.01
		can_collide = true
	elif (event.is_action_pressed("down") or event.is_action_pressed("left") and direction == -1 or event.is_action_pressed("right") and direction == 1) and $OrbitingObject.ring_num > 0:
		$OrbitingObject.between_ring_progress -= 0.01
		can_collide = true
		


func _on_animation_finished() -> void:
	if animation == "hit":
		play("default")
	elif animation == "death":
		SceneSwitcher.switch("res://ui/title_screen/title_screen.tscn")


func _on_death_sound_timing_timeout() -> void:
	get_parent().get_parent().screenshake = 15
	SFX.play(SFX.Id.GAME_OVER)
