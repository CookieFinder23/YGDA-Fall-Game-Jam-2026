extends Node
class_name OrbitingObject
## 1 indexed. ring 1 is innermost; ring 4 is outermost. automatically clamps to legal value
var ring_num = 3:
	set(new_value):
		ring_num = clamp(new_value, 0, MAX_RING_NUM)
## position along ring in radians
var ring_pos = 0
## radian gain on ring per second
const SPEED = 0.5
const MAX_RING_NUM = 4
