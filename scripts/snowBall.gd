extends CharacterBody3D

@export var SPEED = 7.0
@export var rot_speed : Vector3
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explosion: Node3D = $explosion
@onready var snow: GPUParticles3D = $Node3D/Snow
@onready var quick_flash: GPUParticles3D = $Node3D/QuickFlash
@onready var fire: GPUParticles3D = $Node3D/Fire



var spawnPos : Vector3
var spawnRot : float
var hit = false
var shoot_at : Vector3
var throw_angle_degrees: float
var initial_speed: float
var gravity: float = 9.8
var time: float = 0.0

var z_axis = 0.0
var is_launch: bool = false

func _ready() -> void:
	global_position = spawnPos
	rotation.y = spawnRot
	fire.emitting = true
	

	
func _physics_process(delta: float) -> void:
	velocity = global_basis * Vector3.BACK * SPEED
	mesh_instance_3d.rotation += rot_speed
	if hit and not animation_player.is_playing():
		queue_free()
	move_and_slide()
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	rot_speed = Vector3.ZERO
	snow.emitting = true
	mesh_instance_3d.visible = false
	animation_player.play("explosion")
	hit = true

func _on_timer_timeout() -> void:
	self.queue_free()

func launch_projectile(direction : Vector2, desired_distance: float, desired_angle_deg: float):
	var inital_pos = spawnPos
	var throw_direction = direction.normalized()
	
	throw_angle_degrees = desired_angle_deg
	initial_speed = pow(desired_distance * gravity / sin(2 * deg_to_rad(desired_angle_deg)), 0.5)
	
	z_axis = 0
	is_launch = true
	
