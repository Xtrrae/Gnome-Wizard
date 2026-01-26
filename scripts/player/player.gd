extends CharacterBody3D

@onready var gnome: Node3D = $gnome
@onready var hitbox: CollisionShape3D = $hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cam: Camera3D = $cam
@onready var ray_cast_3d: RayCast3D = $RayCast3D

var last_direction
var lerp_speed = 0.08
var sprint_speed = 7.5
var turn_speed = 0.04
var pushing = false;
var speed = 5.0

const BASE_SPEED = 5.0
const JUMP_VELOCITY = 6.0

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		
		if Input.is_action_just_released("jump"):
			velocity = lerp(velocity, get_gravity() * delta * 50, 0.3)
		else:
			velocity += get_gravity() * delta
	
	
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and Input.is_action_pressed("sprint") and pushing == false:
		
		direction = lerp(last_direction, direction, turn_speed)
		gnome.rotation.y = lerp_angle(gnome.rotation.y, atan2(velocity.x, velocity.z), lerp_speed)

		velocity.x = direction.x * sprint_speed
		velocity.z = direction.z * sprint_speed
		
		last_direction = direction
	elif direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		gnome.rotation.y = lerp_angle(gnome.rotation.y, atan2(velocity.x, velocity.z), lerp_speed)
		
		last_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	pushing = true
