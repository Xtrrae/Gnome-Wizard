extends CharacterBody3D

@export var carmera_sensitivity = 0.004

@onready var gnome: Node3D = $gnome
@onready var hitbox: CollisionShape3D = $hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cam: Camera3D = $cam
@onready var main = self.get_parent()
@onready var projectile = load("res://scenes/fireball.tscn")
@onready var pivot_center: Node3D = $pivot_center
@onready var pivot_forward: Node3D = $pivot_center/pivot_forward
@onready var ray_cast_3d: RayCast3D = $pivot_center/RayCast3D
@onready var step_up: RayCast3D = $pivot_center/StepUp


var last_direction
var lerp_speed = 0.08
var sprint_speed = 7.5
var turn_speed = 0.04
var pushing : bool
var speed = 5.0
var on_ground = true
var on_box = false
var direction : Vector3
var current_rot : float
var wall_infront = false
var barrel : Array

const BASE_SPEED = 5.0
const JUMP_VELOCITY = 6.0
const STEP_VELOCITY = 2.5

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _physics_process(delta: float) -> void:
	on_ground = is_on_floor()
	# Add the gravity.
	if not (on_box or on_ground):
		
		if Input.is_action_just_released("jump"):
			print(pushing)
			velocity = lerp(velocity, get_gravity() * delta * 50, 0.3)
		else:
			velocity += get_gravity() * delta

	if ray_cast_3d.is_colliding() and pushing:
		for i in barrel.size():
			barrel.get(i).collision_mask = 1
			barrel.get(i).collision_layer = 1
	
	if Input.is_action_just_pressed("jump") and (on_ground or on_box) and not pushing:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and Input.is_action_pressed("sprint") and pushing == false:
		direction = lerp(last_direction, direction, turn_speed)
		current_rot = lerp_angle(gnome.rotation.y, atan2(velocity.x, velocity.z), lerp_speed)
		gnome.rotation.y = current_rot
		pivot_center.rotation.y = current_rot
		velocity.x = direction.x * sprint_speed
		velocity.z = direction.z * sprint_speed
		
		last_direction = direction
	elif direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		current_rot = lerp_angle(gnome.rotation.y, atan2(velocity.x, velocity.z), lerp_speed)
		gnome.rotation.y = current_rot
		pivot_center.rotation.y = current_rot
		last_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if Input.is_action_just_pressed("pause"):
		pass
	
	move_and_slide()

func shoot():
	
	var instance = projectile.instantiate()
	instance.spawnPos = pivot_forward.global_position
	instance.spawnRot = current_rot
	main.add_child.call_deferred(instance)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("push"):
		body.collision_mask = 1
		body.collision_layer = 1
		on_box = true



func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("push"):
		body.collision_mask = 2
		body.collision_layer = 2
		on_box = false

func _on_push_body_entered(body: Node3D) -> void:
	if body.is_in_group("push"):
		barrel.append(body)
		speed = 4.0
		pushing = true

func _on_push_body_exited(body: Node3D) -> void:
	if body.is_in_group("push"):
		barrel.erase(body)
		speed = 5.0
		pushing = false
		body.collision_mask = 2
		body.collision_layer = 2
