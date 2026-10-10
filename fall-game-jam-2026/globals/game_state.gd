extends Node

const RING_AMOUNT = 3
const RING_BASE = 180
const RING_SLOPE = 160
const CENTER = Vector2(960, 540)
var fast_ring: int
var player: Player

func _ready() -> void:
	reset()

func reset() -> void:
	fast_ring = -1
