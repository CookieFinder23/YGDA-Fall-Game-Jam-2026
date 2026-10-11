extends Node2D

var count: int = 0

func _process(delta: float) -> void:
	count = GameState.bosses_killed
