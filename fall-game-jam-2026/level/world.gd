extends Node2D
const FODDER = preload("uid://ocsoo5vljovt")
const BURNER = preload("uid://dhxu81fp4yvqo")

const center = Vector2(480, 270) # canvas is 960 by 540
var player_vars = 0
# an array of all objects which are currently colliding with eachother, and have already bounced off eachother
var recent_collisions = [] # [[obj1, obj2], [obj1, obj2]]

func get_ring_radius(ring_num: int) -> int:
	return 90 + 80 * ring_num

func _ready() -> void:
	for i in range(5):
		var fodder = BURNER.instantiate()
		var orb = fodder.find_child("OrbitingObject")
		orb.ring_num = randi_range(0, 2)
		orb.ring_pos = randf_range(0, 2 * PI)
		if randi_range(0, 1):
			fodder.find_child("BaseEnemy").direction *= -1
		add_child(fodder)

func clean_recent_collisions() -> void:
	var to_remove: Array[int] = []
	var i = 0
	for coll in recent_collisions:
		if not coll[0] or not coll[1] or coll[0].can_collide or coll[1].can_collide:
			to_remove.append(i)
		i += 1
	# reverse bc removing from the start will shift indexes down by one
	to_remove.reverse()
	for index in to_remove:
		recent_collisions.pop_at(index)

func _physics_process(_delta: float) -> void:
	clean_recent_collisions()
	for child in get_children():
		position_orbiting_object(child)
	if $Player/Hitbox.has_overlapping_areas():
		var base_enemy: Node = $Player/Hitbox.get_overlapping_areas()[0].get_parent()
		bounce($Player, base_enemy, 3)
		
	# handle collisions between two enemies
	for child in get_children():
		if is_instance_of(child, Player):
			continue
		var base_enemy = child.find_child("BaseEnemy")
		var hitbox = base_enemy.find_child("Hitbox")
		var overlap = hitbox.get_overlapping_areas()
		if not overlap:
			continue
		var collided_with = overlap[0].get_parent()
		if is_instance_of(collided_with, Player):
			continue
		bounce(base_enemy, collided_with, 3)

## prereq: nodes have variables: direction, speed, speed_mult, bounce
func bounce(obj1: Node, obj2: Node, speed_mult: float):
	if [obj1, obj2] in recent_collisions or [obj2, obj1] in recent_collisions:
		return
	recent_collisions.append([obj1, obj2])
	obj1.can_collide = false
	obj2.can_collide = false
	if is_instance_of(obj1, Player):
		obj2.health -= 1
	elif is_instance_of(obj2, Player):
		obj1.health -= 1
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
	# also multiply their speeds by the speed mult for bouncing
	# this is done by setting the speed mult to the value which will create the correct speed
	var new_speed = max(obj1_base_speed, obj2_base_speed) * speed_mult
	obj1.speed_mult = new_speed / obj1_base_speed
	obj2.speed_mult = new_speed / obj2_base_speed
	
func position_orbiting_object(obj: Node) -> void:
	var orbiting_object: OrbitingObject
	orbiting_object = obj.find_child("OrbitingObject")
	if orbiting_object:
		obj.global_position = center + Vector2(get_ring_radius(orbiting_object.ring_num)*cos(orbiting_object.ring_pos), get_ring_radius(orbiting_object.ring_num)*sin(orbiting_object.ring_pos))
		obj.look_at(center)
		obj.rotation += deg_to_rad(90)
		if (obj if is_instance_of(obj, Player) else obj.find_child("BaseEnemy")).direction == -1:
			obj.rotation += deg_to_rad(180)
