extends Node3D
@export var camera_sensitivity = 0.004 
@export var camera_speed = 1.0 

@onready var cam: Camera3D = $cam

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * camera_sensitivity
		
func _physics_process(delta: float) -> void:
	camera_movement()
	
func camera_movement():
	var direction = Vector2.ZERO
	direction.y = Input.get_axis("camera_down", "camera_up")
	direction.x = Input.get_axis("camera_left", "camera_right")
	
	global_position += (global_basis * Vector3(direction.x, 0, direction.y)).normalized() * camera_speed
