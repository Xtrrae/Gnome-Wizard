extends CharacterBody3D

var vel : Vector3
var direction : Vector3
var lerp_speed = 0.08
var explode := false
var num_walls : Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if explode == true and num_walls.size() > 0:
		for i in num_walls.size():
			num_walls.get(i).queue_free()
		queue_free()
	elif explode == true:
		queue_free()
	
	move_and_slide()
	



func _on_explostion_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("breakable"):
		num_walls.append(body)
		print(num_walls)


func _on_explostion_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("breakable"):
		num_walls.erase(body)
