extends Control

var paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
	
