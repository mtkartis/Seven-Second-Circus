extends KinematicBody2D
#const
const FALL_V = 5
const GRAVITY = 10
const MAX_FALL = 300
#var
var y_velocity = 0
var facing_r = true
var interact_index = -1
var holding_rope = false
var j = true
var balance_timer_active = true
var on_treadmill = false
var curtains_open = false
var broke_plate = false
#obj
onready var plate = $Plate
onready var plate_point = $Plate/Position
onready var plate_joint = $Plate/Joint
onready var reach = $Reach
onready var rope = $Rope
onready var rope_tip = $Rope/Position2D
onready var animation_player = $AnimationPlayer
onready var image = $Image
#signals
signal plate_still
signal plate_move
signal open_door
signal plate_fail

#--------------------READY--------------------
func _ready():
	global_position = Global.player_position
	Global.stability = 50
	image.frame = 0
	#room index to set initial stuff
	if Global.room_index == 1: #stage
		curtains_open = false
		toggle_plate(true)
		toggle_rope(false)
	if Global.room_index == 2:
		curtains_open = true
		toggle_plate(false)
		toggle_rope(false)
	
#-------------------MOVEMENT-----------------
func _physics_process(delta):
	var x_input = Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT")
	if curtains_open == true:
		move_and_slide(Vector2(x_input*Global.speed,y_velocity),Vector2(0,-1))
	#TREADMILL EXERCISE
	if on_treadmill == true and x_input != 0:
		print("on")
		Global.speed_stat += 0.05
		Global.speed_stat = clamp(Global.speed_stat,0,200)
	
	#JUMPING
	var grounded = is_on_floor()
	y_velocity += GRAVITY
	#jump
	if Input.is_action_just_pressed("JUMP") and grounded:
		y_velocity -= Global.jump
	#landing (keeping a gravity constant for floor contact)
	if grounded and y_velocity >= 5:
		y_velocity = 5
	#clamp max fall
	if y_velocity > MAX_FALL:
		y_velocity = MAX_FALL
		
	#STILL DETECTION
	if balance_timer_active == true:
		if has_node("Plate"):
			if abs(plate.linear_velocity.x) < 5:
				emit_signal("plate_move")
			else:
				emit_signal("plate_still")
	#ANIMATION
	if broke_plate == true:
		if x_input == 0:
			#idle
			animate("PanicIdle")
		else:
			#walk
			animate("PanicWalk")
	else:
		if grounded:
			if x_input == 0:
				#idle
				animate("Idle")
			else:
				#walk
				animate("Walk")
				pass
		else:
			#jumping
			animate("Jump")
		pass
	#FLIP DETECT
	if x_input < 0 and facing_r == true:
		horiz_flip()
	if x_input > 0 and facing_r == false:
		horiz_flip()
		
	#REACH COLLISIONS
	var collisions = reach.get_overlapping_areas()
	print(collisions)
	if collisions != []:
		#treadmill
		if collisions[0].name == "Treadmill":
			if grounded:
				Global.treadmill_clamp_speed("on")
				on_treadmill = true
			else:
				Global.treadmill_clamp_speed("off")
				on_treadmill = false
		#interactible
		if collisions[0].name == "Door" or collisions[0].name == "JumpRope":
			interact_index = collisions[0].type
	else:
		interact_index = -1
	#REACH HAZARD DETECT
	var hazard_collisions = reach.get_overlapping_bodies()
	if hazard_collisions != []:
#		if hazard_collisions[0].name == "Hazard":
		hit()
	
	#DETECT ROPE
	if rope.rotation_degrees == 0:
		if grounded == true:
			print("failed jump")
		else:
			Global.jump += 1
			Global.jump = clamp(Global.jump,0,350)
			
	#DETECT PLATE
	#if plate in scene
	if has_node("Plate"):
		#if below horizontal, fail and detatch
		if (plate_point.global_position.y - plate.global_position.y) >= 1:
			fallen_plate()
		#if detatched and on ground, delete
		if j == false:
			if plate.linear_velocity.y <= 5:
				plate.queue_free()
		
func fallen_plate():
		if j == true:
			j = false
			plate_joint.queue_free()
		Global.drop_plate = true
		Global.change_player_speed()
		Global.stability = 0
		emit_signal("plate_fail")
		if Global.room_index == 1:
			broke_plate = true
		
#--------------ANIMATE-----------------
func animate(index):
	if animation_player.is_playing() and animation_player.current_animation == index:
		return
	else:
		animation_player.play(index)

func horiz_flip():
	facing_r = !facing_r
	image.flip_h = !image.flip_h
#--------------INTERACT PRESS CONTROLLER----------
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("INTERACT"):
			print("interact")
			#check interact index
			#door
			if interact_index == 0:
				emit_signal("open_door")
			#vending machine
			if interact_index == 1:
#					add_child() vending machine
				pass
			#rope
			if holding_rope == false:
				if interact_index == 2:
					toggle_rope(true)
			else:
				toggle_rope(false)
				
				
func end_interaction():
	#plate
	toggle_plate(false)
	#rope
	toggle_rope(false)

#------------PLATE CONTROLLER------------
func toggle_plate(toggle):
	plate.visible = toggle
	plate.applied_force.y = -Global.stability

#------------ROPE CONTROLLER--------------
func toggle_rope(toggle):
	holding_rope = toggle
	rope.visible = toggle
	if toggle == true:
		rope.start()
	else:
		rope.reset()

#------------------HIT DETECT-----------
func hit():
	print("ow")
	if has_node("Plate"):
		plate.angular_velocity = 50
		emit_signal("plate_fail")
		
#-------------CURTAIN SIGNAL-------------
func curtains_opened():
	curtains_open = true
