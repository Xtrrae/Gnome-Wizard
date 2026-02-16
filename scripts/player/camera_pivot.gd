extends Node3D
@export var camera_sensitivity = 0.04 
@export var turn_sensitivity = 0.5
@export var camera_speed = 1.0 
@export var max_zoom = 5.0
@export var max_pan = 20.0
@export var zoom_speed = 1.0
@export var lerp_speed = 1.0
@onready var player: CharacterBody3D = $"../Player"

@onready var camera_3d: Camera3D = $Camera3D

var start_pos : Vector2

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("move_camera"):
			global_position.x = global_position.x - (event.relative.x * camera_sensitivity)
			global_position.z = global_position.z - (event.relative.y * camera_sensitivity)
		
func _physics_process(delta: float) -> void:
	camera_movement()
	camera_zoom()
	
func camera_movement():
	var direction = Vector2.ZERO
	direction.y = Input.get_axis("camera_up", "camera_down")
	direction.x = Input.get_axis("camera_left", "camera_right")
	
	global_position += (global_basis * Vector3(direction.x, 0, direction.y)).normalized() * camera_speed

func camera_zoom():
	if Input.is_action_just_pressed("zoom") and camera_3d.size > max_zoom:
		camera_3d.size = lerp(camera_3d.size,camera_3d.size - zoom_speed, lerp_speed)
	if Input.is_action_just_pressed("pan") and camera_3d.size < max_pan:
		camera_3d.size = lerp(camera_3d.size,camera_3d.size + zoom_speed, lerp_speed)
