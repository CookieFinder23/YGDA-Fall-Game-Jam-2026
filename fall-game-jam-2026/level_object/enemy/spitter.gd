extends Sprite2D

const BULLET = preload("uid://c34kvcjryav0p")

func _ready() -> void:
	reset_timer()

func reset_timer() -> void:
	$Cooldown.start(randf_range(2.5, 3.5))

func _on_cooldown_timeout() -> void:
	var bullet = BULLET.instantiate()
	bullet.direction = $BaseEnemy.direction
	bullet.flip_h = $BaseEnemy.direction == -1
	var bullet_orb: OrbitingObject = bullet.find_child("OrbitingObject")
	var my_orb: OrbitingObject = $BaseEnemy/OrbitingObject
	bullet_orb.ring_pos = my_orb.ring_pos + 0.1
	bullet_orb.ring_num = my_orb.ring_num
	get_parent().add_child(bullet)
	reset_timer()
