extends CharacterBody3D

@export var SPEED = 5.0


var dir : Vector3
var spawnPos : Vector3
var spawnRot : Vector3

func _ready() -> void:
	print(dir)

	global_position = spawnPos
	global_rotation.x = spawnRot.x
	global_rotation.z = spawnRot.z
	
func _physics_process(delta: float) -> void:
	velocity.x = dir.x * SPEED
	velocity.z = dir.z * SPEED

	
	move_and_slide()
