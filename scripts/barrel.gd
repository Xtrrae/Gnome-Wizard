extends CharacterBody3D

var vel : Vector3
var direction : Vector3
var lerp_speed = 0.08

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_slide()


func _on_push_detection_body_entered(body: Node3D) -> void:
	
	if body.is_in_group("player"):
		body.speed = 4.0
		body.pushing = true
		
		if Input.is_action_pressed("pull"):
			vel = body.velocity
			vel += lerp(vel, body.velocity - direction, lerp_speed)
			print("pulling")


func _on_push_detection_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.speed = 5.0
		body.pushing = false
