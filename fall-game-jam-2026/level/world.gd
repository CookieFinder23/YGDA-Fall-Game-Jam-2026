extends Node2D

var radius = 50
var rings = [radius, 2*radius, 3*radius, 4*radius, 5*radius]
var center = Vector2(480, 270)

func _process(delta: float) -> void:
	print($Player.ring_num)
	#canvas is 960 by 540
	$Player.global_position = center + Vector2(rings[$Player.ring_num]*cos($Player.ring_pos), rings[$Player.ring_num]*sin($Player.ring_pos))
