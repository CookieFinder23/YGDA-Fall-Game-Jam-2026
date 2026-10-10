extends Node2D

const BASE_RADIUS: int = 60
var rings_radii: Array[int] = [BASE_RADIUS, 2*BASE_RADIUS, 3*BASE_RADIUS, 4*BASE_RADIUS]
const center = Vector2(480, 270) # canvas is 960 by 540
var player_vars = 0

func _ready() -> void:
	for child in get_children():
		var orb = child.find_child("OrbitingObject")
		orb.ring_num = randi_range(0, 3)
		orb.ring_pos = randf_range(0, 2 * PI)
func _physics_process(_delta: float) -> void:
	for child in get_children():
		position_orbiting_object(child)
	if $Player.collision_cooldown_dist_timer < 0 and $Player/Hitbox.has_overlapping_areas():
		$Player.collision_cooldown_dist_timer = $Player.COLLISION_COOLDOWN_DIST
		var base_enemy: Node = $Player/Hitbox.get_overlapping_areas()[0].get_parent()
		base_enemy.health -= 1
		bounce($Player, base_enemy)
		
	# handle collisions between two enemies
	var already_collided: Array = []
	for child in get_children():
		if is_instance_of(child, Player):
			continue
		var hitbox = child.find_child("Hitbox")
		var base_enemy = hitbox.get_parent()
		if hitbox in already_collided or base_enemy.collision_cooldown_dist_timer > 0:
			continue
		if hitbox.has_overlapping_areas():
			already_collided.append(hitbox)
			# only need to mark one part of the collision as already collided to prevent the exact collision between the two happening again
			# using an array of length 2 containing both and checking if the collision exactly matches may be better, but lazy
			var collided_with = hitbox.get_overlapping_areas()[0].get_parent()
			if is_instance_of(collided_with, Player):
				continue
			base_enemy.collision_cooldown_dist_timer = base_enemy.COLLISION_COOLDOWN_DIST
			collided_with.collision_cooldown_dist_timer = collided_with.COLLISION_COOLDOWN_DIST
			bounce(child.get_node("BaseEnemy"), collided_with)

## prereq: nodes have variables: direction, speed, speed_mult, bounce
func bounce(obj1: Node, obj2: Node):
	var obj1_base_speed = obj1.SPEED if "SPEED" in obj1 else obj1.speed
	var obj1_speed = obj1_base_speed * obj1.speed_mult
	var obj2_base_speed = obj2.SPEED if "SPEED" in obj2 else obj2.speed
	var obj2_speed = obj2_base_speed * obj2.speed_mult
	
	# the slower object takes the direction of the faster object, then invert the direction of the faster object
	if obj1_speed > obj2_speed:
		obj2.direction = obj1.direction
		obj1.direction *= -1
	else:
		obj1.direction = obj2.direction
		obj2.direction *= -1
		
	# the speed of each object is set to the max speed
	# this is done by setting the speed mult to the value which will create the correct speed
	var new_speed = max(obj1_speed, obj2_speed)
	obj1.speed_mult = new_speed / obj1_base_speed
	obj2.speed_mult = new_speed / obj2_base_speed
	
func position_orbiting_object(obj: Node) -> void:
	var orbiting_object: OrbitingObject
	orbiting_object = obj.find_child("OrbitingObject")
	if orbiting_object:
		obj.global_position = center + Vector2(rings_radii[orbiting_object.ring_num]*cos(orbiting_object.ring_pos), rings_radii[orbiting_object.ring_num]*sin(orbiting_object.ring_pos))
		obj.look_at(center)
