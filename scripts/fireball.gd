extends CharacterBody3D

@export var SPEED = 7.0
@export var rot_speed : Vector3
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var spawnPos : Vector3
var spawnRot : float

func _ready() -> void:
	global_position = spawnPos
	rotation.y = spawnRot
	
	
func _physics_process(delta: float) -> void:
	velocity = global_basis * Vector3.BACK * SPEED
	mesh_instance_3d.rotation += rot_speed
	print(animation_player.animation_finished)

	
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	animation_player.play("explosion")



func _on_timer_timeout() -> void:
	self.queue_free()
