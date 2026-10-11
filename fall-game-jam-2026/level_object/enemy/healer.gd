extends Sprite2D
class_name Healer

func _ready() -> void:
	GameState.active_healer = true

func _on_base_enemy_damaged() -> void:
	frame = 1
