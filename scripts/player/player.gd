extends CharacterBody3D

@export var carmera_sensitivity = 0.004

@onready var gnome: Node3D = $gnome
@onready var hitbox: CollisionShape3D = $hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var main = self.get_parent()
@onready var projectile = load("res://scenes/fireball.tscn")
@onready var pivot_center: Node3D = $pivot_center
@onready var pivot_forward: Node3D = $pivot_center/pivot_forward
@onready var ray_cast_3d: RayCast3D = $pivot_center/RayCast3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var camera_3d: Camera3D = $"../Camera_pivot/Camera3D"
@onready var steps: AudioStreamPlayer3D = $Steps
@onready var timer: Timer = $Timer
@onready var fireball: AudioStreamPlayer3D = $Fireball
@onready var despawn: CollisionShape3D = $snowballDespawn/DESPAWN



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
var is_playing = false
var spell_type := 0
var hit_pos

const BASE_SPEED = 5.0
const JUMP_VELOCITY = 6.0
const STEP_VELOCITY = 2.5

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _physics_process(delta: float) -> void:
	on_ground = is_on_floor()
	fireball.play()
	if not (on_box or on_ground):
		
		if Input.is_action_just_released("jump"):
			velocity = lerp(velocity, get_gravity() * delta * 50, 0.3)
		else:
			velocity += get_gravity() * delta

	if ray_cast_3d.is_colliding():
		for i in barrel.size():
			barrel.get(i).collision_mask = 1
			barrel.get(i).collision_layer = 1
	
	if Input.is_action_just_pressed("jump") and (on_ground or on_box) and not pushing:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var cam_basis = camera_3d.global_transform.basis
	
	var forward = cam_basis.z
	forward.y = 0
	forward = forward.normalized()
	
	var right = cam_basis.x
	right.y = 0
	right = right.normalized()

	direction = (right * input_dir.x + forward * input_dir.y).normalized()
	if direction and Input.is_action_pressed("sprint") and pushing == false:
		direction = lerp(last_direction, direction, turn_speed)
		current_rot = lerp_angle(gnome.rotation.y, atan2(direction.x, direction.z), lerp_speed)
		gnome.rotation.y = current_rot
		velocity.x = direction.x * sprint_speed
		velocity.z = direction.z * sprint_speed
		
		last_direction = direction
		if not is_playing:
			steps.play(1.20)
			is_playing = true
			timer.start()
	elif direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		current_rot = lerp_angle(gnome.rotation.y, atan2(direction.x, direction.z), lerp_speed)
		gnome.rotation.y = current_rot
		last_direction = direction
		if not is_playing:
			steps.play(1.20)
			is_playing = true
			timer.start()
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		steps.stop()
		timer.start(-14.99)
	
	
	if Input.is_action_just_pressed("pause"):
		pass
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action("shoot"):
		var camera = camera_3d
		var mouse_pos = event.position
		var ray_length = 100
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * ray_length
		var space = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.from = from
		ray_query.to = to
		var result = space.intersect_ray(ray_query)
		hit_pos = result.position
		if result.size() < 1:
			return
		print(result.position)
		mesh_instance_3d.global_position = result.position + Vector3(0, .5, 0)
		despawn.global_position = result.position + Vector3(0, .5, 0)
		pivot_center.rotation.y = atan2(-self.position.x + result.position.x, -self.position.z + result.position.z)
	if Input.is_action_just_pressed("shoot"):
		if spell_type == 0:
			fireball.play()
			var projectile = preload("res://scenes/player/fireball.tscn")
			var instance = projectile.instantiate()
			instance.spawnPos = pivot_forward.global_position
			instance.spawnRot = pivot_center.rotation.y
			main.add_child.call_deferred(instance)
		if  spell_type == 1:
			var projectile = preload("res://scenes/player/Snowball.tscn")
			var instance = projectile.instantiate()
			instance.spawnPos = pivot_forward.global_position
			instance.spawnRot = pivot_center.rotation.y
			instance.hit_pos.x = hit_pos.x
			instance.hit_pos.y = hit_pos.z
			main.add_child.call_deferred(instance)
			
	if Input.is_action_just_pressed("switch to fireball"):
		print("fireball")
		spell_type = 0
	if Input.is_action_just_pressed("switch to snowball"):
		print("snowball")
		spell_type = 1



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("push"):
		body.collision_mask = 257
		body.collision_layer = 257
		on_box = true



func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("push"):
		body.collision_mask = 258
		body.collision_layer = 258
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
		body.collision_mask = 258
		body.collision_layer = 258


func _on_timer_timeout() -> void:
	is_playing = false
