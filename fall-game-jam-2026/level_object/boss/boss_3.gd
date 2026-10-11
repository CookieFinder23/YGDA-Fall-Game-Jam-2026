extends Sprite2D
const ELECTRICITY_BALL = preload("uid://bnpvoj5h7k6k1")

func _ready() -> void:
	var left_ball = ELECTRICITY_BALL.instantiate()
	left_ball.boss = self
	left_ball.rad_offset = -1.0
	
	var right_ball = ELECTRICITY_BALL.instantiate()
	right_ball.boss = self
	right_ball.rad_offset = 1.0
	
	add_sibling(left_ball)
	add_sibling(right_ball)
