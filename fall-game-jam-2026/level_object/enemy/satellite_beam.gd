extends Area2D

func _ready() -> void:
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.size = Vector2(16.0, 160.0)

func _on_area_entered(area: Area2D) -> void:
	area.get_parent().health -= 1

func _process(_delta: float) -> void:
	$CollisionShape2D.shape.size.y = 160 - $AnimatedSprite2D.frame * 30
	$CollisionShape2D.position.y = (160 - $CollisionShape2D.shape.size.y) / -2.0
	if not $AnimatedSprite2D.flip_v:
		$CollisionShape2D.position.y *= -1
