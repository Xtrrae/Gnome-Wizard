extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var num_on_button : Array
var pressed = false
var unpressed = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name != "buttonCollision":
		num_on_button.append(body)
		animation_player.play("press_down")
		pressed = true
		unpressed = false

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name != "buttonCollision":
		num_on_button.erase(body)
	if num_on_button.size() == 0:
		animation_player.play("press_up")
		pressed = false
		unpressed = true
