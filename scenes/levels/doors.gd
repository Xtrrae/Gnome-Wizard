extends Node

@onready var button: StaticBody3D = $"../../button"
@onready var door_1_player: AnimationPlayer = $door1Player
@onready var door_2_player: AnimationPlayer = $door2Player



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if button.pressed == true and not door_1_player.is_playing() and not door_2_player.is_playing():
		
		
		door_2_player.play("2nd_wall_up")
		door_1_player.play("1st_wall_down")
		button.pressed = false
	if button.unpressed == true and not door_1_player.is_playing() and not door_2_player.is_playing():
		door_2_player.play("2nd_wall_down")
		door_1_player.play("1st_wall_up")
		button.unpressed = false
		
