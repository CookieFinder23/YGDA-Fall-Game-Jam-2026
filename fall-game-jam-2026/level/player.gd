extends Sprite2D

var ring_num = 3
## position along ring in radians
var ring_pos = 0
## radian gain on ring per second
const SPEED = 0.5
## 1 indexed. ring 1 is innermost; ring 4 is outermost
const MAX_RING_NUM = 4
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ring_pos += SPEED * delta
	if ring_pos > 2 * PI:
		ring_pos -= 2 * PI
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up") and ring_num < MAX_RING_NUM:
		ring_num += 1
	elif event.is_action_pressed("down") and ring_num > 0:
		ring_num -= 1
		
