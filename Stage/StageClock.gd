extends MarginContainer
#var
var countdown = true
var countdown_text = 3
var countdown_lock = false
var time = 7.0
var timer_go = true
var pause = false
var init = false
#obj
onready var countdown_timer = $Countdown
onready var timer = $Timer7
onready var text = $RichTextLabel
#signal
signal hazard_start

#-------------RUN--------------
func _process(delta):
	if init == true:
		if countdown == true:
			if countdown_lock == false:
				countdown_lock = true
				countdown_timer.start()
				print("start")
		else:
			text.set_text("%f" % float(timer.time_left))
			timer.paused = pause
			if timer_go == true:
				timer_go = false
				start()

func countdown_tick():
	if countdown_text == 0:
		countdown = false
		countdown_timer.stop()
		emit_signal("hazard_start")
	text.set_text("%s" % int(countdown_text))
	countdown_text -= 1
	print(countdown_text)

func start():
	timer.start()
	
#link to plate_move
func pause_clock():
	pause = true
func go_clock():
	pause = false

#BALANCE FOR 7 SECONDS
func win():
	Global.win = true
	print("win")
	
func plate_fail():
	countdown_timer.stop()
	timer_go = false

func curtains_open():
	init = true
