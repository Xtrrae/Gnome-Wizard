extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name != "buttonCollision":
		animation_player.play("press_down")


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name != "buttonCollision":
		animation_player.play("press_up")
