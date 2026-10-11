extends Node2D

func _physics_process(_delta: float) -> void:
	if $RayCast2D.is_colliding():
		$Line2D.points[1] = $RayCast2D.get_collision_point()
	else:
		$Line2D.points[1] = Vector2(960.0, 0.0)
	$Area2D/CollisionShape2D.size.x = $Line2D.points[1].x
	$Area2D/CollisionShape2D.position.x = $Area2D/CollisionShape2D.size.x / -2.0
func _on_area_2d_area_entered(_area: Area2D) -> void:
	GameState.player.health -= 1
