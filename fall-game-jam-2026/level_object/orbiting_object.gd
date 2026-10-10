extends Node
class_name OrbitingObject
## 0 indexed. ring 0 is innermost; ring 3 is outermost. automatically clamps to legal value
var ring_num = 2:
	set(new_value):
		ring_num = clamp(new_value, 0, MAX_RING_NUM)
## position along ring in radians
var ring_pos = 0
## radian gain on ring per second
const MAX_RING_NUM = 2

func move(dist: float):
	ring_pos += dist / ((90 + 80 * ring_num) / 80)
	if ring_pos > 2 * PI:
		ring_pos -= 2 * PI
