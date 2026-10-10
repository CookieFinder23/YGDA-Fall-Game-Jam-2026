extends Node
class_name OrbitingObject
## 0 indexed. ring 0 is innermost; ring 2 is outermost. automatically clamps to legal value
var ring_num = 2:
	set(new_value):
		ring_num = clamp(new_value, 0, GameState.RING_AMOUNT - 1)
var between_ring_progress: float = 0.0
## position along ring in radians
var ring_pos = 0
const FAST_RING_MULT = 2
const MOVE_BETWEEN_RING_SPEED = 20

func move(dist: float):
	dist = dist / ((GameState.RING_BASE + GameState.RING_SLOPE * ring_num) / GameState.RING_SLOPE)
	if ring_num == GameState.fast_ring:
		dist *= FAST_RING_MULT
	ring_pos += dist
	if ring_pos > 2 * PI:
		ring_pos -= 2 * PI

func _physics_process(delta: float) -> void:
	if between_ring_progress > 0 and between_ring_progress < 1.0:
		between_ring_progress += delta * MOVE_BETWEEN_RING_SPEED
	if between_ring_progress < 0 and between_ring_progress > -1.0:
		between_ring_progress -= delta * MOVE_BETWEEN_RING_SPEED
	if between_ring_progress > 1.0:
		between_ring_progress = 0.0
		ring_num += 1
	if between_ring_progress < -1.0:
		between_ring_progress = 0.0
		ring_num -= 1
