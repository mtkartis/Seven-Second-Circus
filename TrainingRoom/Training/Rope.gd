extends RayCast2D
#vars
var swinging = false
var swing_speed = 5
#obj
onready var timer = $Timer
#------------START--------------
func _ready():
	swinging = false
	rotation_degrees

#--------------SWING CONTROLLER--------------
func _process(delta):
	if swinging == true:
		swing()
	if rotation_degrees >= 360:
		rotation_degrees = 0
	
func swing():
		rotation_degrees += swing_speed
		
func start():
	timer.start()

func timer_timeout():
	swinging = true
	timer.stop()

func reset():
	rotation_degrees = 45
	timer.stop()
	swinging = false
