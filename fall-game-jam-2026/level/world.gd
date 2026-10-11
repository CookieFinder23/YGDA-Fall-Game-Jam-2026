extends Node2D
const FODDER = preload("uid://ocsoo5vljovt")
const BURNER = preload("uid://dhxu81fp4yvqo")
const BOSS_1 = preload("uid://3tbia1bfkjgc")
const SPITTER = preload("uid://c6vs4d5loklld")

var player_vars = 0
# an array of all objects which are currently colliding with eachother, and have already bounced off eachother
var recent_collisions = [] # [[obj1, obj2], [obj1, obj2]]

func get_ring_radius(ring_num: float) -> float:
	return GameState.RING_BASE + GameState.RING_SLOPE * ring_num

func _ready() -> void:
	var boss = BOSS_1.instantiate()
	var orb = boss.find_child("OrbitingObject")
	orb.ring_num = randi_range(0, 2)
	orb.ring_pos = randf_range(0, 2 * PI)
	if randi_range(0, 1):
		boss.find_child("BaseEnemy").direction *= -1
	$Orbiting.add_child(boss)
	for i in range(5):
		await get_tree().physics_frame
		summon()

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
	var boss_found = false
	clean_recent_collisions()
	for child in $Orbiting.get_children():
		if not boss_found and child.find_child("BaseBoss"):
			boss_found = true
		position_orbiting_object(child)
	if not boss_found:
		GameState.fast_ring = -1
	if $Orbiting/Player/Hitbox.has_overlapping_areas():
		var base_enemy: Node = $Orbiting/Player/Hitbox.get_overlapping_areas()[0].get_parent()
		bounce($Orbiting/Player, base_enemy, 2)
		
	# handle collisions between two enemies
	for child in $Orbiting.get_children():
		if is_instance_of(child, Player) or is_instance_of(child, Projectile):
			continue
		var base_enemy = child.find_child("BaseEnemy")
		var hitbox = base_enemy.find_child("Hitbox")
		var overlap = hitbox.get_overlapping_areas()
		if not overlap:
			continue
		var collided_with = overlap[0].get_parent()
		if is_instance_of(collided_with, Player):
			continue
		bounce(base_enemy, collided_with, 2)

## prereq: nodes have variables: direction, speed, speed_mult, bounce
func bounce(obj1: Node, obj2: Node, speed_mult: float):
	if [obj1, obj2] in recent_collisions or [obj2, obj1] in recent_collisions:
		return
	
	recent_collisions.append([obj1, obj2])
	obj1.can_collide = false
	obj2.can_collide = false
	if is_instance_of(obj1, Player):
		obj2.health -= 1
		SFX.play(SFX.Id.PLAYER_BOUNCE)
	elif is_instance_of(obj2, Player):
		obj1.health -= 1
		SFX.play(SFX.Id.PLAYER_BOUNCE)
	else:
		SFX.play(SFX.Id.ENEMY_BOUNCE)
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
		var base_enemy = obj.find_child("BaseEnemy")
		var ring_num_increase: float = 0.0
		if base_enemy:
			ring_num_increase += (10.0 / max(base_enemy.spawn_progress * 10, 0.1) )- 1
		obj.global_position = ring_coords_to_pos(orbiting_object.ring_num + orbiting_object.between_ring_progress + ring_num_increase, orbiting_object.ring_pos)
		if is_instance_of(obj, Projectile):
			return
		if is_instance_of(obj, Player):
			obj.flip_v = obj.direction == 1
			obj.look_at(GameState.CENTER)
			obj.rotation += deg_to_rad(180)
			return
		if not base_enemy.random_rotate:
			obj.look_at(GameState.CENTER)
			obj.rotation += deg_to_rad(90)
			obj.flip_h = base_enemy.direction == -1

func ring_coords_to_pos(ring_num: float, ring_pos: float):
	return GameState.CENTER + Vector2(get_ring_radius(ring_num)*cos(ring_pos), get_ring_radius(ring_num)*sin(ring_pos))

func summon() -> void:
	if len($Orbiting.get_children()) > 10:
		return
	for i in range(50):
		var spawn_rad = fmod(($Orbiting/Player/OrbitingObject.ring_pos + deg_to_rad(randf_range(170, 190))), (2.0 * PI))
		var min_ring_diffs = {
			0: 9,
			1: 9,
			2: 9
		}
		
		for child in $Orbiting.get_children():
			var orb = child.find_child("OrbitingObject")
			var child_rad = orb.ring_pos
			var diff = abs(spawn_rad - child_rad)
			if diff > PI:
				diff -= 2 * PI
			diff = abs(diff)
			if diff < min_ring_diffs[orb.ring_num]:
				min_ring_diffs[orb.ring_num] = diff
		min_ring_diffs[0] -= 4
		min_ring_diffs[1] -= 2
		var max_ring_diff = 0
		for ring in min_ring_diffs:
			if min_ring_diffs[ring] > max_ring_diff:
				max_ring_diff = min_ring_diffs[ring]
		if max_ring_diff < 0.75:
			continue
		var viable = []
		for ring in min_ring_diffs:
			if min_ring_diffs[ring] == max_ring_diff:
				viable.append(ring)
		var spawn_ring = viable.pick_random()
		var enemy = [FODDER, BURNER, SPITTER].pick_random()
		var to_spawn = enemy.instantiate()
		var to_spawn_orb = to_spawn.find_child("OrbitingObject")
		to_spawn_orb.ring_num = spawn_ring
		to_spawn_orb.ring_pos = spawn_rad
		if randi_range(0, 1):
			to_spawn.find_child("BaseEnemy").direction *= -1
		to_spawn.find_child("BaseEnemy").speed *= randf_range(0.8, 1.2)
		$Orbiting.add_child(to_spawn)
		return

func _on_summon_cooldown_timeout() -> void:
	$SummonCooldown.wait_time = max((len($Orbiting.get_children()) / 2.0) - max(GameState.difficulty_ramp / 10.0, 1), 0.25)
	summon()
