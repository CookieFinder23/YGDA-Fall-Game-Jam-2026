extends Node2D
class_name Enemy
const PARTICLES = preload("uid://b1suesqbkn8r0")
var can_collide = true
@export var speed: float = 0.5
@export var direction: int = 1
@export var hitbox: RectangleShape2D
signal damaged
@export var random_rotate: bool = false
@export var health: int = 1:
	set(new_value):
		if health == new_value:
			return
		var took_damage = false
		if new_value < health:
			health = new_value
			took_damage = true
			damaged.emit()
			$IFrames.start()
		else:
			health = new_value
		
		
		if health <= 0:
			var to_kill = get_parent()
			if is_instance_of(to_kill, BaseBoss):
				to_kill = to_kill.get_parent()
				GameState.fast_ring = -1
				GameState.slow_ring = -1
				GameState.difficulty_ramp = 0
				GameState.bosses_killed += 1
				GameState.tutorial = false
				SFX.play(SFX.Id.BOSS_DEFEAT)
				GameState.boss = null
			elif is_instance_of(to_kill, Healer):
				GameState.player.health += 1
				to_kill.get_parent().get_parent().mod_target = Color(0.1, 1.0, 0.1, 0.25)
				SFX.play(SFX.Id.HEAL)
			else:
				SFX.play(SFX.Id.ENEMY_KILL)
			var particles = PARTICLES.instantiate()
			particles.global_position = global_position
			to_kill.get_parent().get_parent().add_child(particles)
			to_kill.queue_free()
		elif took_damage:
			SFX.play(SFX.Id.ENEMY_DAMAGE)
@export var spawn_progress: float = 0.0
const BOUNCE_SMOOTH = 0.01
var speed_mult: float = 1.0

func _ready() -> void:
	$Hitbox/CollisionShape2D.shape = hitbox

func _physics_process(delta: float) -> void:
	if spawn_progress < 1:
		spawn_progress += delta * 8
		$Hitbox/CollisionShape2D.disabled = true
		return
	$Hitbox/CollisionShape2D.disabled = not $IFrames.is_stopped()
	spawn_progress = 1
	var movement = speed * speed_mult * direction * delta
	if not $Hitbox.has_overlapping_areas():
		can_collide = true
	$OrbitingObject.move(movement)
	# if confused about this line read https://www.rorydriscoll.com/2016/03/07/frame-rate-independent-damping-using-lerp/
	speed_mult = lerp(speed_mult, 1.0, 1 - pow(BOUNCE_SMOOTH, delta))
	
	if random_rotate:
		var parent = get_parent()
		if is_instance_of(parent, BaseBoss):
			parent = parent.get_parent()
		parent.rotation += delta * direction
	
