extends Camera3D

@export var follow_target: Node3D
@export var look_target: Node3D

var lerp_speed = 0.009
var zoom = 45.0
var pan = 85.0
var default_fov = 65.0
var cam_pos = Vector3(0, 4, 6)

func _process(delta):
	cam_zoom()
	cam_follow()
	cam_pan()
	
func cam_zoom():
	if Input.is_action_pressed("zoom") && self.fov >= zoom:
		self.fov = lerp(self.fov, zoom, lerp_speed)
	elif !Input.is_action_pressed("zoom") && self.fov <= default_fov:
		self.fov = lerp(self.fov, default_fov, lerp_speed)
		

func cam_pan(): 
	if Input.is_action_pressed("pan") and self.fov <= pan:
		self.fov = lerp(self.fov, pan, lerp_speed)
	elif not Input.is_action_pressed("pan") and self.fov >= default_fov:
		self.fov = lerp(self.fov, default_fov, lerp_speed)

func cam_follow():
		if follow_target != null:
			self.position = lerp(self.position, follow_target.position + cam_pos, lerp_speed)
			look_at(look_target.global_position)
