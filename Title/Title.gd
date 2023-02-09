extends Node
#var
#obj
onready var textbox = $StartTextbox
onready var timer = $Timer
#----------------START------------------
func _ready():
	timer.start()

#--------------------"START" FLASH MODULATOR-----------
func flash():
	textbox.visible = !textbox.visible

#----------------INPUT DETECTOR--------------
func _input(event):
	if event is InputEventKey:
		Global.room_index = 2
		Global.player_position = Vector2(144,184)
		get_tree().change_scene("res://TrainingRoom/TrainingRoom.tscn")
