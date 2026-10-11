extends Node2D

func _ready() -> void:
	$Area2D/CollisionShape2D.shape = RectangleShape2D.new()
	$Area2D/CollisionShape2D.shape.size.y = 32

func _physics_process(_delta: float) -> void:
	if $RayCast2D.is_colliding():
		$Line2D.set_point_position(1, Vector2($RayCast2D.get_collision_point().distance_to(global_position), 0.0))
	else:
		$Line2D.set_point_position(1, Vector2(1920.0, 0.0))

	$Area2D/CollisionShape2D.shape.size.x = $Line2D.get_point_position(1).x
	$Area2D/CollisionShape2D.position.x = $Area2D/CollisionShape2D.shape.size.x / 2.0
func _on_area_2d_area_entered(_area: Area2D) -> void:
	GameState.player.health -= 1
