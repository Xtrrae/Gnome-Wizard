extends CharacterBody3D

@export var SPEED = 7.0
@export var rot_speed : Vector3
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explosion: Node3D = $explosion
@onready var sparks: GPUParticles3D = $explosion/Sparks
@onready var quick_flash: GPUParticles3D = $explosion/QuickFlash
@onready var fire: GPUParticles3D = $explosion/Fire
@onready var smoke: GPUParticles3D = $explosion/Smoke


var spawnPos : Vector3
var spawnRot : float
var hit = false

func _ready() -> void:
	global_position = spawnPos
	rotation.y = spawnRot
	fire.emitting = true
	smoke.emitting = true
	
func _physics_process(delta: float) -> void:
	velocity = global_basis * Vector3.BACK * SPEED
	mesh_instance_3d.rotation += rot_speed
	
	if hit and not animation_player.is_playing():
		queue_free()
		hit = false
		
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	rot_speed = Vector3.ZERO
	animation_player.play("explosion")
	hit = true
	if body.is_in_group("push"):
		body.explode = true
		sparks.emitting = true
		quick_flash.emitting = true
		fire.emitting = true
		smoke.emitting = true
	else:
		fire.emitting = true
		smoke.emitting = true
		quick_flash.emitting = true

func _on_timer_timeout() -> void:
	self.queue_free()
