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
var hit_pos : Vector2

func _ready() -> void:
	global_position = spawnPos
	rotation.y = spawnRot
	fire.emitting = true

	
func _physics_process(delta: float) -> void:
	print(global_position)
	velocity = global_basis * Vector3.BACK * SPEED
	mesh_instance_3d.rotation += rot_speed
	if (global_position.x == hit_pos.x and global_position.z == hit_pos.y):
		
		queue_free()

	if hit and not animation_player.is_playing():
		queue_free()
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	rot_speed = Vector3.ZERO
	animation_player.play("explosion")
	if body.name == "DESPAWN" and global_position.x == hit_pos.x and global_position.z == hit_pos.y:
		queue_free()
	hit = true

func _on_timer_timeout() -> void:
	self.queue_free()
