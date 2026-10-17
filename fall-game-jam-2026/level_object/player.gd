extends AnimatedSprite2D
class_name Player

var first_damage = true
const BOUNCE_SMOOTH = 0.1
var can_collide = true
var dead = false
const MAX_HEALTH = 5
var health: int = 5:
	set(new_health):
		new_health = clamp(new_health, 0, MAX_HEALTH)
		var damaged = new_health < health
		if dead or new_health == health or damaged and not $IFrames.is_stopped():
			return
		if new_health > health:
			get_parent().get_parent().mod_target = Color(0.1, 1.0, 0.1, 0.25)
		if new_health <= 0:
			get_parent().get_parent().screenshake += 15
			SFX.play(SFX.Id.TAKE_DAMAGE)
			get_parent().get_parent().mod_target = Color(1, 0.1, 0.1, 0.6)
			modulate.r += 2
			dead = true
			health = 0
			play("death")
			$Hitbox/CollisionShape2D.disabled = true
			can_collide = false
			$DeathSoundTiming.start()
			return
		
		
		health = new_health
		if damaged and not (first_damage and GameState.tutorial):
			Engine.time_scale = 0.5
			speed_mult = 0.8
			get_parent().get_parent().screenshake += 12
			get_parent().get_parent().mod_target = Color(1, 0.1, 0.1, 0.2)
			SFX.play(SFX.Id.TAKE_DAMAGE)
			modulate.r += 2
			play("hit")
			$IFrames.start()
		first_damage = false
## radian change per second
const SPEED: float = 2.0
## 1 = radians increasing, -1 = radians decreasing
var direction: int = 1
var speed_mult: float = 1

func _ready() -> void:
	GameState.player = self
	$OrbitingObject.ring_pos = PI
	$OrbitingObject.ring_num = 1
	if GameState.tutorial:
		GameState.healer_storage += 1
		health -= 2
func _physics_process(delta: float) -> void:
	modulate = modulate.lerp(Color(1, 1, 1), 1 - pow(0.1, delta))
	if dead:
		return
	var movement = SPEED * speed_mult * direction * delta
	if $OrbitingObject.ring_num == GameState.slow_ring:
		movement *= 0.5
		$CPUParticles2D2.visible = true
		$CPUParticles2D2.emitting = true
	else:
		$CPUParticles2D2.emitting = false

	if $OrbitingObject.ring_num == GameState.fast_ring:
		$CPUParticles2D.visible = true
		$CPUParticles2D.emitting = true
	else:
		$CPUParticles2D.emitting = false
	$OrbitingObject.move(movement)
	if not $Hitbox.has_overlapping_areas():
		can_collide = true
	
	# if confused about this line read https://www.rorydriscoll.com/2016/03/07/frame-rate-independent-damping-using-lerp/
	speed_mult = lerp(speed_mult, 1.0, 1 - pow(BOUNCE_SMOOTH, delta))
	$CPUParticles2D.direction.y = direction
	$CPUParticles2D.position.y = direction * 50
	$CPUParticles2D2.direction.y = direction
	$CPUParticles2D2.position.y = direction * 50

func _input(event: InputEvent) -> void:
	if dead or $OrbitingObject.between_ring_progress:
		return
	
	var mobile_input = 0
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		var diff = GameState.CENTER.distance_to(event.position) - GameState.CENTER.distance_to(global_position)
		if not abs(diff) < 100:
			mobile_input = sign(diff)

	if (mobile_input == 1\
		or event.is_action_pressed("up")\
		or event.is_action_pressed("left") and direction == 1\
		or event.is_action_pressed("right") and direction == -1\
		or event.is_action_pressed("aleft") and position.x < GameState.CENTER.x\
		or event.is_action_pressed("aright") and position.x > GameState.CENTER.x\
		or event.is_action_pressed("aup") and position.y < GameState.CENTER.y\
		or event.is_action_pressed("adown") and position.y > GameState.CENTER.y)\
		and $OrbitingObject.ring_num < GameState.RING_AMOUNT - 1:
		$OrbitingObject.between_ring_progress += 0.01
		can_collide = true
	elif (mobile_input == -1\
		or event.is_action_pressed("down")\
		or event.is_action_pressed("left") and direction == -1\
		or event.is_action_pressed("right") and direction == 1\
		or event.is_action_pressed("aleft") and position.x > GameState.CENTER.x\
		or event.is_action_pressed("aright") and position.x < GameState.CENTER.x\
		or event.is_action_pressed("aup") and position.y > GameState.CENTER.y\
		or event.is_action_pressed("adown") and position.y < GameState.CENTER.y)\
		and $OrbitingObject.ring_num > 0:
		$OrbitingObject.between_ring_progress -= 0.01
		can_collide = true
		


func _on_animation_finished() -> void:
	if animation == "hit":
		play("default")
	elif animation == "death":
		SceneSwitcher.switch("res://ui/title_screen/title_screen.tscn")


func _on_death_sound_timing_timeout() -> void:
	get_parent().get_parent().screenshake += 15
	SFX.play(SFX.Id.GAME_OVER)
