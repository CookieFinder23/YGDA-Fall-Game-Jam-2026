extends Sprite2D

var points = []

var old_dir = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if $BaseEnemy.spawn_progress < 1:
		return
	if $BaseEnemy.direction != old_dir:
		points = []
		old_dir = $BaseEnemy.direction
	points.append(global_position)
	var pop_i = -1
	var index = 0
	for point in points:
		if point.distance_to(global_position) > 100:
			pop_i = index
		index += 1
	if pop_i != -1:
		for i in range(pop_i + 1):
			points.remove_at(0)
	var top = global_position.direction_to(GameState.CENTER) * 25
	var bottom = global_position.direction_to(GameState.CENTER) * -25
	var shape_points = [top, bottom, points[0] - global_position]
	$Red.polygon = shape_points
	var orange_points = [global_position.direction_to(GameState.CENTER) * 20, global_position.direction_to(GameState.CENTER) * -20, (points[0] - global_position) * 0.7]
	$Orange.polygon = orange_points
	$Red.rotation = rotation * -1
	$Orange.rotation = rotation * -1
	$Out.global_position = $Orange.global_position + $Orange.polygon[2]
func _on_out_area_entered(_area: Area2D) -> void:
	GameState.player.health -= 1
