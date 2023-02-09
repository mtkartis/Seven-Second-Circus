extends Node2D
#vars
var open = false
var move_curtain = false
#obj
onready var curtain_l = $CurtainL
onready var curtain_r = $CurtainR
onready var timer = $Timer
#singals
signal open

#---------MOVE DELAY-----------
func _ready():
	timer.start()
	
func timer_timeout():
	move_curtain = true

#-------------MAIN LOOP---------------
func _process(delta):
	if move_curtain == true:
		curtain_move()
	
#------------OPEN--------------
func curtain_move():
	var close_limit = (curtain_l.texture.get_size().x/4)
	#closed --> open
	if open == false:
		curtain_l.position.x -= 1
		curtain_r.position.x += 1
	#open --> closed
	if open == true:
		curtain_l.position.x += 1
		curtain_r.position.x -= 1
	#if moved to limit (open)
	if curtain_l.position.x == -(close_limit*3):
		open = true
		move_curtain = false
		emit_signal("open")
		return
	if curtain_l.position.x == -close_limit:
		open = false
		move_curtain = false
		return

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_home"):
			move_curtain = true
