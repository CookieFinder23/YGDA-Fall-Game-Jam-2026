extends Node2D

var radius = 50
var rings = [radius, 2*radius, 3*radius, 4*radius, 5*radius]
var center = Vector2(480, 270) # canvas is 960 by 540
var player_vars = 0

func _process(_delta: float) -> void:
	if $Player/Hitbox.has_overlapping_areas():
		$Player.direction *= -1
	for child in get_children():
		position_orbiting_object(child)
	

func position_orbiting_object(obj) -> void:
	var vars = obj.find_child("OrbitingObject")
	if vars:
		obj.global_position = center + Vector2(rings[vars.ring_num]*cos(vars.ring_pos), rings[vars.ring_num]*sin(vars.ring_pos))
