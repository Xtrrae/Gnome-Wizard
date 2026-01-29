extends CharacterBody3D

@export var SPEED = 2.0


var dir : Vector3
var spawnPos : Vector3
var spawnRot : Vector3

func _ready() -> void:
	print(global_position)

	global_position = spawnPos + (dir * 10)
	global_rotation.x = spawnRot.x
	global_rotation.z = spawnRot.z
	
func _physics_process(delta: float) -> void:
	velocity.x = dir.x * SPEED
	velocity.z = dir.z * SPEED
	move_and_slide()
