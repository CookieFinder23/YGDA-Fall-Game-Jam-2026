extends Node2D

var max_out = 0

func _ready() -> void:
	$Area2D/CollisionShape2D.shape = RectangleShape2D.new()
	$Area2D/CollisionShape2D.shape.size.y = 16

func _physics_process(delta: float) -> void:
	max_out += delta * 500
	if $RayCast2D.is_colliding():
		$Line2D.set_point_position(1, Vector2(min($RayCast2D.get_collision_point().distance_to(global_position), max_out), 0.0))
	else:
		$Line2D.set_point_position(1, Vector2(min(1920.0, max_out), 0.0))
	$Area2D/CollisionShape2D.shape.size.x = $Line2D.get_point_position(1).x
	$Area2D/CollisionShape2D.position.x = $Area2D/CollisionShape2D.shape.size.x / 2.0
func _on_area_2d_area_entered(_area: Area2D) -> void:
	GameState.player.health -= 1
