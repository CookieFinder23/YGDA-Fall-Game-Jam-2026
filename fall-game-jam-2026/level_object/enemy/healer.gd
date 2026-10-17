extends Sprite2D
class_name Healer

func _ready() -> void:
	if GameState.tutorial:
		$BaseEnemy.direction = -1

func _on_base_enemy_damaged() -> void:
	frame = 1
