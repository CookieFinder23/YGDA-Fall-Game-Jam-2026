extends Sprite2D

var beam_dir = 1
func _ready() -> void:
	if $BaseEnemy/OrbitingObject.ring_num == 0:
		beam_dir = 1
	elif $BaseEnemy/OrbitingObject.ring_num == GameState.RING_AMOUNT - 1:
		beam_dir = -1
	elif randi_range(0, 1):
		beam_dir = -1
	$SatelliteBeam.position.y = 112 * beam_dir
	$SatelliteBeam/Sprite2D.flip_v = beam_dir == -1
