extends Camera3D

@export var follow_target: Node3D
@export var look_target: Node3D

var lerp_speed = 0.05
var zoom = 5.0
var pan = 12.0
var default_fov = 9.0
var cam_pos = Vector3(0, 4, 6)

func _process(delta):
	cam_zoom()
	cam_follow()
	cam_pan()
	
func cam_zoom():
	if Input.is_action_pressed("zoom") && self.size >= zoom:
		self.size = lerp(self.size, zoom, lerp_speed)
	elif !Input.is_action_pressed("zoom") && self.size <= default_fov:
		self.size = lerp(self.size, default_fov, lerp_speed)
		

func cam_pan(): 
	if Input.is_action_pressed("pan") and self.size <= pan:
		self.size = lerp(self.size, pan, lerp_speed)
	elif not Input.is_action_pressed("pan") and self.size >= default_fov:
		self.size = lerp(self.size, default_fov, lerp_speed)

func cam_follow():
		if follow_target != null:
			self.position = lerp(self.position, follow_target.position + cam_pos, lerp_speed)
			look_at(look_target.global_position)
