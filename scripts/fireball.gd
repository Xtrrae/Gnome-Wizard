extends CharacterBody3D

@export var SPEED = 100


var dir : float
var spawnPos : Vector3
var spawnRot : float

func _ready() -> void:
	global_position = spawnPos
	global_rotation.y = spawnRot
	
func _physics_process(delta: float) -> void:
	pass
