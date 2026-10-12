extends Sprite2D
class_name Healer

func _physics_process(_delta: float) -> void:
	GameState.healer_cooldown = 10.0

func _on_base_enemy_damaged() -> void:
	frame = 1
