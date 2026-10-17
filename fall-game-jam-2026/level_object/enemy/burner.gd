extends Sprite2D
const FLAME_HITBOX = preload("uid://dau2agkl5nykq")

func _on_flame_tick_timeout() -> void:
		var flame = FLAME_HITBOX.instantiate()
		flame.global_position = $FlamePoint.global_position
		get_tree().current_scene.add_child(flame)
