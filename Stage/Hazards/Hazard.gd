extends RigidBody2D
#var
export var type = 0
var dir = 0
#dictionaries
var type_dict = {
	0:"tomato",
	1:"sandbag",
}
#obj
onready var image = $Image
onready var detect = $Detect

#-------------START-------------
func _ready():
	image.animation = type_dict[type]
	#if tomato
	if type == 0:
		linear_velocity += Vector2(dir*rand_range(100,250),rand_range(-200,-50))
		angular_velocity += rand_range(-10,10)
		
	#if sandbag
	if type == 1:
		pass

#-------------------MOVE--------------------
func _physics_process(delta):
	var collisions = detect.get_overlapping_bodies()
	if collisions != []:
		if collisions[0] is StaticBody2D:
			queue_free()
		if collisions[0] is KinematicBody2D:
			queue_free()
