extends Label

func _process(delta: float) -> void:
	var string_thing = str(GameState.bosses_killed)
	while string_thing.length() < 3:
		string_thing = "0" + string_thing
	text = string_thing
