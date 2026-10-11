extends Sprite2D
class_name ElectricityBall
@export var boss: Node
@export var rad_offset: float = 1.0
func _physics_process(_delta: float) -> void:
	var orb = boss.find_child("OrbitingObject")
	var dist = rad_offset
	$OrbitingObject.ring_num = orb.ring_num
	dist = dist / ((GameState.RING_BASE + GameState.RING_SLOPE * (orb.ring_num + orb.between_ring_progress)) / GameState.RING_SLOPE)
	dist *= 2
	$OrbitingObject.ring_pos = fmod(orb.ring_pos + dist, 2 * PI)
	$OrbitingObject.between_ring_progress = orb.between_ring_progress
	
func _on_area_2d_area_entered(_area: Area2D) -> void:
	GameState.player.health -= 1
