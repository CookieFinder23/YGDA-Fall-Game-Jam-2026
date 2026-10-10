extends Node2D

@export var speed: float = 0.1
@export var direction: int = 1

@export var health: int = 1:
	set(new_value):
		health = new_value
		if health <= 0:
			queue_free()

func _physics_process(delta: float) -> void:
	$OrbitingObject.move(speed * direction * delta)
