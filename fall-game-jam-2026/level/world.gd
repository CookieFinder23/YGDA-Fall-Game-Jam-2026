extends Node2D

var radius = 50
var rings = [radius, 2*radius, 3*radius, 4*radius, 5*radius]
var center = Vector2(480, 270)
var player_vars = 0

func _process(delta: float) -> void:
	for child in $Player.get_children():
		if (child.name == "OrbitingObject"):
			var player_vars = child
	#canvas is 960 by 540
	$Player.global_position = center + Vector2(rings[player_vars.ring_num]*cos(player_vars.ring_pos), rings[player_vars.ring_num]*sin(player_vars.ring_pos))
