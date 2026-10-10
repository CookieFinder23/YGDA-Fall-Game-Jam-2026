extends Node

const RING_AMOUNT = 3
const RING_BASE = 180
const RING_SLOPE = 160
const CENTER = Vector2(960, 540)
var fast_ring: int
var difficulty_ramp: float = 0.0
var player: Player

func _ready() -> void:
	reset()

func reset() -> void:
	fast_ring = -1
	difficulty_ramp = 0.0
	
func _process(delta: float) -> void:
	difficulty_ramp += delta
