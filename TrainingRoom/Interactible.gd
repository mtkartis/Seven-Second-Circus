extends Area2D
#var exports
export var type = 0
#vars
var player_in = false
#dictionaries
var interact_dict = {
	0:"door",
	1:"vending machine",
	2:"rope",
	3:"treadmill",
	4:"balance",
}

#--------------PLAYER DETECT---------------
func area_entered(body):
	if body is KinematicBody2D:
		player_in = true

func area_exited(body):
	if body is KinematicBody2D:
		player_in = false
