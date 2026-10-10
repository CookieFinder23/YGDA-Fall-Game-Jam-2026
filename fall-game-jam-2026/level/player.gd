extends Sprite2D


var ring_num = 3
var ring_pos_percent = 0
## % gain on ring per second
const SPEED = 5
## 1 indexed. ring 1 is innermost; ring 4 is outermost
const MAX_RING_NUM = 4
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ring_pos_percent += SPEED * delta
	if ring_pos_percent > 100:
		ring_pos_percent -= 100
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
			pass
