extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		
		var next_level_path = "res://scenes/levels/level" + str(next_level_number) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)
