extends Label

var old: String = "000"
var zoom: float = 1.0

func _process(delta: float) -> void:
	var string_thing = str(GameState.bosses_killed)
	while string_thing.length() < 3:
		string_thing = "0" + string_thing
	text = string_thing
	if not old == string_thing:
		print("hah")
		scale.x = 1.1
		scale.y = 1.1
	scale.x = lerp(scale.x, zoom, 1 - pow(0.01, delta))
	scale.y = lerp(scale.y, zoom, 1 - pow(0.01, delta))
	old = string_thing
