extends Node2D
class_name Enemy
var can_collide = true
@export var speed: float = 0.5
@export var direction: int = 1

@export var health: int = 1:
	set(new_value):
		if health == new_value:
			return
		health = new_value
		if health <= 0:
			get_parent().queue_free()

const BOUNCE_SMOOTH = 0.01
var speed_mult: float = 1.0

func _physics_process(delta: float) -> void:
	var movement = speed * speed_mult * direction * delta
	if not $Hitbox.has_overlapping_areas():
		can_collide = true
	$OrbitingObject.move(movement)
	# if confused about this line read https://www.rorydriscoll.com/2016/03/07/frame-rate-independent-damping-using-lerp/
	speed_mult = lerp(speed_mult, 1.0, 1 - pow(BOUNCE_SMOOTH, delta))
