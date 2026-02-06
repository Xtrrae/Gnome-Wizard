extends CharacterBody3D

var vel : Vector3
var direction : Vector3
var lerp_speed = 0.08
var explode := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if explode == true:
		queue_free()
	
	move_and_slide()
	
	
