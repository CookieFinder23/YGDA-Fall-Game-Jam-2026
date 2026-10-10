extends Node
class_name OrbitingObject
## 0 indexed. ring 0 is innermost; ring 2 is outermost. automatically clamps to legal value
var ring_num = 2:
	set(new_value):
		ring_num = clamp(new_value, 0, GameState.RING_AMOUNT - 1)
## position along ring in radians
var ring_pos = 0

func move(dist: float):
	ring_pos += dist / ((GameState.RING_BASE + GameState.RING_SLOPE * ring_num) / GameState.RING_SLOPE)
	if ring_pos > 2 * PI:
		ring_pos -= 2 * PI
