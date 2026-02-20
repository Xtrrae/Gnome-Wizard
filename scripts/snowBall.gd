extends CharacterBody3D

@export var SPEED = 7.0
@export var rot_speed : Vector3
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explosion: Node3D = $explosion
@onready var snow: GPUParticles3D = $Node3D/Snow
@onready var quick_flash: GPUParticles3D = $Node3D/QuickFlash
@onready var fire: GPUParticles3D = $Node3D/Fire
@onready var not_moving_timer: Timer = $not_moving_timer



var spawnPos : Vector3
var hitPos: Vector3
var spawnRot : float
var hit = false
var shoot_at : Vector3
var launch_angle_degrees = 45.0
var initial_speed: float
var gravity: float = 9.8
var time: float = 0.0
var velocity_values: Vector3
var direction : Vector3
var distance : float
var horizontal: Vector3
var angle: float
var height_difference: float
var launched = false

func _ready() -> void:
	fire.emitting = true
	time = 0.0
func _physics_process(delta: float) -> void:
	if not launched:
		return

	# Apply gravity manually
	velocity.y -= gravity * delta
	
	if hit and not animation_player.is_playing():
		queue_free()
	move_and_slide()
	
	if velocity == Vector3.ZERO:
		not_moving_timer.start()

func launch(from: Vector3, to: Vector3):
	global_position = from

	var angle: float = deg_to_rad(launch_angle_degrees)

	var direction: Vector3 = to - from
	var horizontal: Vector3 = Vector3(direction.x, 0.0, direction.z)
	var distance: float = horizontal.length()
	var height_difference: float = direction.y

	if distance < 0.001:
		return

	var velocity_squared = (
	gravity * distance * distance
	) / (
	2.0 * pow(cos(angle), 2.0) *
	(distance * tan(angle) - height_difference)
	)

	if velocity_squared <= 0.0:
		push_warning("Target unreachable with current angle.")
		return

	var speed: float = sqrt(velocity_squared)

	velocity = horizontal.normalized() * speed * cos(angle) + Vector3.UP * speed * sin(angle)

	launched = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	print(body)
	rot_speed = Vector3.ZERO
	snow.emitting = true
	mesh_instance_3d.visible = false
	animation_player.play("explosion")
	hit = true

func _on_timer_timeout() -> void:
	self.queue_free()


	


func _on_not_moving_timer_timeout() -> void:
	queue_free()
