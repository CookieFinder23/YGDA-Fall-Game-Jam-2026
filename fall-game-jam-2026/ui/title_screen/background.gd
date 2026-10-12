extends Sprite2D

func _process(delta: float) -> void:
	var x_modifier = get_global_mouse_position().x
	if x_modifier > GameState.CENTER.x * 2:
		x_modifier = GameState.CENTER.x * 2
	if x_modifier < 0:
		x_modifier = 0
	
	var y_modifier = get_global_mouse_position().y
	if y_modifier > GameState.CENTER.y * 2:
		y_modifier = GameState.CENTER.y * 2
	if y_modifier < 0:
		y_modifier = 0
	$FrontLayer.position.x = x_modifier / 20
	$FrontLayer.position.y = y_modifier / 20
	$BackLayer.position.x = x_modifier / 40
	$BackLayer.position.y = y_modifier / 40
