extends Node
#STATS
var speed_stat = 50 #cap at 100
var normal_speed = 200
var speed = 200
var jump = 200
var stability = 0 #cap at 200
var player_position = Vector2.ZERO #Training room (144,184); Stage (256,184)
var room_index = 0 #0 = title; 1 = stage; 2 = training room
var drop_plate = false

var first_training_room = true
var first_stage = true
var win = false
#dictionaries
var camera_size_dict = {
	"stage":Vector2(512,256),
	"normal":Vector2(512,256),
}
var tutorial_dict = {
	0:"This is the training room. Work out to increase your stats on the right-hand corner.",
	1:"You are the plate-spinning duck! Head out the door to begin your first show! Use the arrow keys to move and jump, and SPACE to interact.",
	2:"This is the jump ropes. Use the interact button to hold the rope. Jump over it as it comes around.",
	3:"This is the treadmill. Jump on to immediately start your workout. Jump off to dismount.",
	4:"DODGE THE TOMATOES.",
	5:"DODGE THE FALLING SANDBAGS.",
	6:"TRY TO BALANCE YOUR PLATE FOR AT LEAST 7 SECONDS. DONT LET IT TOUCH THE GROUND, OR GET HIT BY ANYTHING.",
	7:"RUN FOR COVER! HEAD TO THE TRAINING ROOM!",
	8:"You have won! You are the most fabulous duck to have even spun plates! No tomato or sandbag will ever faze you!",
}
#-------------QUIT-------------
func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
#----------TREADMILL SPEED CONTROLLER-----------
func treadmill_clamp_speed(toggle):
	if toggle == "on":
		speed = 0
	else:
		speed = normal_speed
		
func change_player_speed():
	if drop_plate == true:
		speed = normal_speed
	else:
		if room_index == 2: #leaving stage
			speed = normal_speed
		elif room_index == 1: #leaving training room
			speed = speed_stat
