extends Node2D

const BASE_RADIUS: int = 60
var rings_radii: Array[int] = [BASE_RADIUS, 2*BASE_RADIUS, 3*BASE_RADIUS, 4*BASE_RADIUS]
const center = Vector2(480, 270) # canvas is 960 by 540
var player_vars = 0

func _physics_process(_delta: float) -> void:
	for child in get_children():
		position_orbiting_object(child)
	if $Player/Hitbox.has_overlapping_areas():
		$Player/Hitbox.get_overlapping_bodies()[0].get_node("BaseEnemy").hit()
		$Player.direction *= -1
		$Player.get_node("OrbitingObject").ring_pos += $Player.direction * $Player.SPEED * 0.25

func position_orbiting_object(obj) -> void:
	var vars = obj.find_child("OrbitingObject")
	if vars:
		obj.global_position = center + Vector2(rings_radii[vars.ring_num]*cos(vars.ring_pos), rings_radii[vars.ring_num]*sin(vars.ring_pos))
		obj.look_at(center)
