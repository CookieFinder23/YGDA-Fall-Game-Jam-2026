extends Node

const RING_AMOUNT = 3
const RING_BASE = 180
const RING_SLOPE = 140
const CENTER = Vector2(960, 540)
var fast_ring: int
var slow_ring: int
var difficulty_ramp: float = 0.0
var player: Player
var boss: Node
var bosses_killed: int
var engine_time_scale_vel: float = 0.0
var active_healer: bool = false
var perm_difficulty_ramp = 0.0
func _ready() -> void:
	reset()

func reset() -> void:
	fast_ring = -1
	slow_ring = -1
	difficulty_ramp = 0.0
	perm_difficulty_ramp = 0.0
	bosses_killed = 0
	Engine.time_scale = 1.0
	active_healer = false
	
func _process(delta: float) -> void:
	if not boss:
		fast_ring = -1
		slow_ring = -1
	difficulty_ramp += delta
	perm_difficulty_ramp += delta
	if Engine.time_scale != 1.0:
		engine_time_scale_vel *= pow(2.0, delta)
		Engine.time_scale = move_toward(Engine.time_scale, 1.0, engine_time_scale_vel * 0.01)
	else:
		engine_time_scale_vel = 1.0
