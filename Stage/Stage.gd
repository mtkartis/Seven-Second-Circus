extends Node
#preload
const HAZARD = preload("res://Stage/Hazards/Hazard.tscn")
#var
#obj
onready var sandbag_spawn_point = $SandbagSpawn/SandbagSpawnPoint
onready var spawn_timer = $SpawnTimer
onready var camera = $StageCam
onready var tomato_spawn_left = $Left
onready var tomato_spawn_right =$Right
onready var exit_arrow = $Background/ExitArrow
onready var tutorial = $Background/Tutorial

func _ready():
	camera.current = true
	#TUTORIAL MODULATOR
	if Global.first_stage == true:
		Global.first_stage = false
		tutorial.visible = true
	else:
		tutorial.visible = false

#-------------RANDOMIZE SANDBAGS--------------
#link from timeout
func spawn_sandbag():
	#randomize placement
	randomize()
	sandbag_spawn_point.h_offset = rand_range(10,500)
	#init sandbag
	var sandbag = HAZARD.instance()
	sandbag.type = 1
	sandbag.global_position = sandbag_spawn_point.global_position
	add_child(sandbag)
	

func spawn_tomato():
	randomize()
	var side = randi() % 3
	#velocity already randomized in tomato scene
	if side == 0:
		#from left
		var tomato_l = HAZARD.instance()
		tomato_l.type = 0
		tomato_l.dir = 1
		tomato_l.global_position = tomato_spawn_left.global_position
		add_child(tomato_l)
	elif side == 1:
		#from right
		var tomato_r = HAZARD.instance()
		tomato_r.type = 0
		tomato_r.dir = -1
		tomato_r.global_position = tomato_spawn_right.global_position
		add_child(tomato_r)
	elif side == 2:
		pass
#-----------ARROW MANAGER-------------
func arrows():
	exit_arrow.visible = true
	
func plate_fail():
	arrows()
	tutorial.visible = false
#----------------SCENE CHANGER-----------
func door_interact():
	Global.player_position = Vector2(144,184)
	Global.room_index = 2
	Global.change_player_speed()
	get_tree().change_scene("res://TrainingRoom/TrainingRoom.tscn")

func init_hazards():
	spawn_timer.start()
