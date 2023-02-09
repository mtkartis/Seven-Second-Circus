extends Node
#vars
#obj
onready var camera = $TrainingCam
onready var tutorial_1 = $Background/InitTutorial
onready var tutorial_2 = $Background/Tutorial2
onready var tutorial_3 = $Background/Win

#-------------------START---------------
func _ready():
	camera.make_current()
	#TUTORIAL MODULATOR
	if Global.win == true:
		tutorial_3.visible = true
		tutorial_1.visible = false
		tutorial_2.visible = false
	else:
		if Global.first_training_room == true:
			Global.first_training_room = false
			tutorial_1.visible = true
			tutorial_2.visible = false
			tutorial_3.visible = false
		else:
			tutorial_1.visible = false
			tutorial_2.visible = true
			tutorial_3.visible = false
		


func door_open():
	Global.player_position = Vector2(256,184)
	Global.room_index = 1
	Global.drop_plate = false
	Global.change_player_speed()
	get_tree().change_scene("res://Stage/Stage.tscn")
