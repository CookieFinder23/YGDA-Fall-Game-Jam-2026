extends Area2D

func _ready() -> void:
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.size = Vector2(16.0, 160.0)

func _on_area_entered(area: Area2D) -> void:
	area.get_parent().health -= 1

func _process(_delta: float) -> void:
	var new_size = 0
	match $AnimatedSprite2D.frame:
		0:
			new_size = 0
		1:
			new_size = 40
		2:
			new_size = 70
		3:
			new_size = 100
		4:
			new_size = 125
	$CollisionShape2D.shape.size.y = new_size
	$CollisionShape2D.position.y = (160 - $CollisionShape2D.shape.size.y) / 2.0
	if $AnimatedSprite2D.flip_v:
		$CollisionShape2D.position.y *= -1


func _on_ready_timeout() -> void:
	$AnimatedSprite2D.play("default")
