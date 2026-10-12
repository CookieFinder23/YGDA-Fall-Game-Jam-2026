extends Sprite2D

var target_y: float = 0

func _ready() -> void:
	position.x = -360
	position.y = 600 #for like a cool start up thingy but can change to 0 if it looks bad

func _process(delta: float) -> void:
	#print(target_y)
	position.x += 2
	if(position.x > 360):
		position.x = -360
	position.y = lerp(position.y, target_y, 1 - pow(0.005, delta))
