extends Sprite2D
class_name Projectile
@export var direction = 1
@export var speed = 2

func _on_hitbox_area_entered(area: Area2D) -> void:
	area.get_parent().health -= 1
	queue_free()
	
func _physics_process(delta: float) -> void:
	var movement = delta * direction * speed
	$OrbitingObject.move(delta * direction * speed)
	rotation += movement * 1.5

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
