extends Node2D
const ASTEROID = preload("uid://ocsoo5vljovt")
const SATELLITE = preload("uid://dhxu81fp4yvqo")
const SPITTER = preload("uid://c6vs4d5loklld")
const HEALER = preload("uid://bgjivfvi4ka43")
const COMET = preload("uid://b6aygywfpi7pl")
const BURNER = preload("uid://cyjhjkhs17g6l")

const BOSS_1 = preload("uid://3tbia1bfkjgc")
const BOSS_2 = preload("uid://bvesx0w72475a")
const BOSS_3 = preload("uid://bcc8fl3p6k20b")
const BOSS_4 = preload("uid://co1vshum3px2d")
const HIT_PARTICLES = preload("uid://dfe8icwbp8nwk")
var screenshake_inc: float = 0
var target_offset: Vector2
var mod_target: Color = Color(0, 0, 0, 0)
var last_boss
var last_enemy
const FAST_RING_COLOR = Color(1.987, 3.294, 1.365)
const SLOW_RING_COLOR = Color(2.884, 1.169, 0.841, 1.0)
var player_vars = 0
var rotate_offset = 0
# an array of all objects which are currently colliding with eachother, and have already bounced off eachother
var recent_collisions = [] # [[obj1, obj2], [obj1, obj2]]
var screenshake = 0

func get_ring_radius(ring_num: float) -> float:
	return GameState.RING_BASE + GameState.RING_SLOPE * ring_num

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

func modulate_rings() -> void:
	var default = Color(1, 1, 1)
	$Rings/SmallRing.modulate = default 
	$Rings/MediumRing.modulate = default
	$Rings/LargeRing.modulate = default
	if GameState.fast_ring == 0:
		$Rings/SmallRing.modulate = FAST_RING_COLOR 
	elif GameState.fast_ring == 1:
		$Rings/MediumRing.modulate = FAST_RING_COLOR
	elif GameState.fast_ring == 2:
		$Rings/LargeRing.modulate = FAST_RING_COLOR
	if GameState.slow_ring == 0:
		$Rings/SmallRing.modulate = SLOW_RING_COLOR 
	elif GameState.slow_ring == 1:
		$Rings/MediumRing.modulate = SLOW_RING_COLOR
	elif GameState.slow_ring == 2:
		$Rings/LargeRing.modulate = SLOW_RING_COLOR

func _physics_process(delta: float) -> void:
	screenshake_inc -= delta
	if screenshake_inc < 0:
		screenshake_inc = 0.05
		target_offset = Vector2(randf_range(screenshake * -1, screenshake), randf_range(screenshake * -1, screenshake))
		screenshake -= 150 * delta
		if screenshake < 0.1:
			screenshake = 0
			target_offset = Vector2.ZERO
	$Camera2D.offset = $Camera2D.offset.move_toward(target_offset, delta * 1000)
	var target_zoom = (1 + (1 - $Orbiting/Player.speed_mult) / 50)
	var new_zoom = move_toward($Camera2D.zoom.x, target_zoom, delta)
	$Camera2D.zoom = Vector2(new_zoom, new_zoom)
	$Color.modulate.a = move_toward($Color.modulate.a, mod_target.a, delta)
	$Color.modulate = Color(mod_target.r, mod_target.g, mod_target.b, $Color.modulate.a)
	if $Color.modulate.a == mod_target.a:
		mod_target.a = 0
	modulate_rings()
	clean_recent_collisions()
	for child in $Orbiting.get_children():
		position_orbiting_object(child)
		if child is Sprite2D or child is AnimatedSprite2D:
			child.self_modulate.v = 1
			child.self_modulate.v /= 10
			if child.self_modulate.v < 1:
				child.self_modulate.v = 1
		if child.get_parent() is Sprite2D or child.get_parent() is AnimatedSprite2D:
			child.get_parent().self_modulate.v = 1
			child.get_parent().self_modulate.v /= 10
			if child.get_parent().self_modulate.v < 1:
				child.get_parent().self_modulate.v = 1
	if $Orbiting/Player/Hitbox.has_overlapping_areas():
		var base_enemy: Node = $Orbiting/Player/Hitbox.get_overlapping_areas()[0].get_parent()
		bounce($Orbiting/Player, base_enemy, 2)
		
	# handle collisions between two enemies
	for child in $Orbiting.get_children():
		if is_instance_of(child, Player) or is_instance_of(child, Projectile) or is_instance_of(child, ElectricityBall):
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
	if obj1 is Player and obj1.dead or obj2 is Player and obj2.dead:
		return
	
	var hit = false
	recent_collisions.append([obj1, obj2])
	obj1.can_collide = false
	obj2.can_collide = false
	if is_instance_of(obj1, Player):
		hit = true
		obj2.health -= 1
		if obj2.get_parent() is Sprite2D or obj2.get_parent() is AnimatedSprite2D:
			obj2.get_parent().self_modulate.v = 100000
		if obj2.get_parent().get_parent() is Sprite2D or obj2.get_parent().get_parent() is AnimatedSprite2D:
			obj2.get_parent().get_parent().self_modulate.v = 100000
	elif is_instance_of(obj2, Player):
		hit = true
		obj1.health -= 1
		if obj1.get_parent() is Sprite2D or obj1.get_parent() is AnimatedSprite2D:
			obj1.get_parent().self_modulate.v = 100000
		if obj1.get_parent().get_parent() is Sprite2D or obj1.get_parent().get_parent() is AnimatedSprite2D:
			obj1.get_parent().get_parent().self_modulate.v = 100000
	else:
		SFX.play(SFX.Id.ENEMY_BOUNCE)
	if hit:
		screenshake += 10
		var particles = HIT_PARTICLES.instantiate()
		particles.global_position = (obj1.global_position + obj2.global_position) / 2
		add_child(particles)
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
	if is_instance_of(obj1, Player):
		obj1.speed_mult *= 1.5
	elif is_instance_of(obj2, Player):
		obj2.speed_mult *= 1.5
	
func position_orbiting_object(obj: Node) -> void:
	var orbiting_object: OrbitingObject
	orbiting_object = obj.find_child("OrbitingObject")
	if orbiting_object:
		var base_enemy = obj.find_child("BaseEnemy")
		var ring_num_increase: float = 0.0
		if base_enemy:
			ring_num_increase += (10.0 / max(base_enemy.spawn_progress * 10, 0.1) )- 1
		obj.global_position = ring_coords_to_pos(orbiting_object.ring_num + orbiting_object.between_ring_progress + ring_num_increase, orbiting_object.ring_pos)
		if is_instance_of(obj, ElectricityBall):
			return
		if obj is Projectile:
			obj.flip_h = obj.direction == -1
			obj.look_at(GameState.CENTER)
			obj.rotation += deg_to_rad(270)
			return
		if is_instance_of(obj, Player):
			obj.flip_v = obj.direction == -1
			obj.look_at(GameState.CENTER)
			return
		if not base_enemy.random_rotate:
			obj.look_at(GameState.CENTER)
			if is_instance_of(obj, Satellite):
				obj.rotation += deg_to_rad(90)
			elif obj is Shooter:
				obj.rotation += deg_to_rad(270)
				obj.flip_h = base_enemy.direction == -1
			else:
				obj.rotation += deg_to_rad(90)
				obj.flip_h = base_enemy.direction == -1

func ring_coords_to_pos(ring_num: float, ring_pos: float):
	return GameState.CENTER + Vector2(get_ring_radius(ring_num)*cos(ring_pos), get_ring_radius(ring_num)*sin(ring_pos))

func summon(force_enemy=null) -> void:
	var spawn_rad = fmod(($Orbiting/Player/OrbitingObject.ring_pos + deg_to_rad(180)), 2.0 * PI)
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
	min_ring_diffs[0] -= 1
	min_ring_diffs[1] -= 0.5
	if force_enemy == HEALER:
		min_ring_diffs[2] = 0
	if $Orbiting/Player/OrbitingObject.ring_num != 2:
		min_ring_diffs[$Orbiting/Player/OrbitingObject.ring_num] = 0
	var max_ring_diff = 0
	for ring in min_ring_diffs:
		if min_ring_diffs[ring] > max_ring_diff:
			max_ring_diff = min_ring_diffs[ring]
	if max_ring_diff < 0.75:
		return
	var viable = []
	for ring in min_ring_diffs:
		if min_ring_diffs[ring] == max_ring_diff:
			viable.append(ring)
	var spawn_ring = viable.pick_random()
	var enemy = [ASTEROID, SATELLITE, SPITTER, COMET].pick_random()
	if force_enemy:
		enemy = force_enemy
	else:
		while enemy == last_enemy:
			enemy = [ASTEROID, SATELLITE, SPITTER, COMET].pick_random()
		
		if GameState.healer_storage:
			GameState.healer_storage = false
			enemy = HEALER
		elif GameState.boss_cooldown < 0:
			enemy = [BOSS_1, BOSS_2, BOSS_3, BOSS_4].pick_random()
			while enemy == last_boss:
				enemy = [BOSS_1, BOSS_2, BOSS_3, BOSS_4].pick_random()
			last_boss = enemy
		else:
			last_enemy = enemy
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
	$SummonCooldown.wait_time = max(0, 3.0 - max(GameState.difficulty_ramp / 10.0, 2) - GameState.bosses_killed / 3.0) + randf_range(0.0, 0.5)
	var enemy = null
	if GameState.tutorial:
		if GameState.healer_storage:
			GameState.healer_storage = false
			enemy = HEALER
		elif len($Orbiting.get_children()) == 1:
			enemy = BOSS_1
			last_boss = BOSS_1
		elif not GameState.boss:
			return
		elif GameState.boss.find_child("BaseEnemy").health > 2:
			enemy = ASTEROID
			last_enemy = ASTEROID
	summon(enemy)
