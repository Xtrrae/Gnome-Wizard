extends Node

@onready var button: StaticBody3D = $"../button"
@onready var button_4: StaticBody3D = $"../button4"
@onready var button_3: StaticBody3D = $"../button3"
@onready var button_2: StaticBody3D = $"../button2"
@onready var animation_player: AnimationPlayer = $door1/AnimationPlayer
@onready var animation_player3: AnimationPlayer = $door3/AnimationPlayer
@onready var animation_player2: AnimationPlayer = $door2/AnimationPlayer
@onready var animation_player4: AnimationPlayer = $door4/AnimationPlayer

var door1_up = false
var door2_up = true
var door3_up = true
var door4_up = true
var play_anim_1 = false
var play_anim_2 = false
var play_anim_3 = false
var play_anim_4 = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _process(delta: float) -> void:
	if button.pressed:
		door1_up = !door1_up
		door2_up = !door2_up
		play_anim_1 = true
		play_anim_2 = true
		button.pressed = false
		
	elif button.unpressed:
		door1_up = !door1_up
		door2_up = !door2_up

		play_anim_1 = true
		play_anim_2 = true
		button.unpressed = false
	
	if button_2.pressed:
		door1_up = !door1_up
		door2_up = !door2_up
		door4_up = ! door4_up
		play_anim_1 = true
		play_anim_2 = true
		play_anim_4 = true
		button_2.pressed = false
		
	elif button_2.unpressed:
		door1_up = !door1_up
		door2_up = !door2_up
		door4_up = !door4_up
		play_anim_1 = true
		play_anim_2 = true
		play_anim_4 = true
		button_2.unpressed = false
	
	if door1_up and play_anim_1:
		animation_player.play("Door_1_up")
		play_anim_1 = false
	elif  !(door1_up) and play_anim_1:
		animation_player.play("Door_1_down")
		play_anim_1 = false
	
	if door2_up and play_anim_2:
		animation_player2.play("door_2_up")
		play_anim_2 = false
	elif  !(door2_up) and play_anim_2:
		animation_player2.play("door_2_down")
		play_anim_2 = false

	if button_3.pressed :
		door1_up = !door1_up
		door3_up = !door3_up
		play_anim_1 = true
		play_anim_3 = true
		button_3.pressed = false
		
	elif button_3.unpressed:
		door1_up = !door1_up
		door3_up = !door3_up
		play_anim_1 = true
		play_anim_3 = true
		button_3.unpressed = false
		
	if door1_up and play_anim_1:
		animation_player.play("Door_1_up")
		play_anim_1 = false
	elif  !(door1_up) and play_anim_1:
		animation_player.play("Door_1_down")
		play_anim_1 = false
	
	if button_4.pressed :
		door3_up = !door3_up
		play_anim_3 = true
		button_4.pressed = false
		
	elif button_4.unpressed:
		door3_up = !door3_up
		play_anim_3 = true
		button_4.unpressed = false
		
	if door3_up and play_anim_3:
		animation_player3.play("door_3_up")
		play_anim_3 = false
	elif  !(door3_up) and play_anim_3:
		animation_player3.play("door_3_down")
		play_anim_3 = false
		
	if door4_up and play_anim_4:
		animation_player4.play("door_4_up")
		play_anim_4 = false
	elif  !(door4_up) and play_anim_4:
		animation_player4.play("door_4_down")
		play_anim_4 = false
		
		
