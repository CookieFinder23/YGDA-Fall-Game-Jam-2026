extends Sprite2D

@export var direction = 1
@export var speed = 1

func _on_hitbox_area_entered(area: Area2D) -> void:
	area.get_parent().health -= 1

func _physics_process(delta: float) -> void:
	$OrbitingObject.move(delta * direction * speed)
