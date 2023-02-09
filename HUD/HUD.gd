extends MarginContainer
#vars
#obj
onready var speed_text = $VBoxContainer/Speed/Text
onready var jump_text =$VBoxContainer/Jump/Text

#----------PROCESS------------
func _process(delta):
	speed_text.set_text("%s" % int(Global.speed_stat-49))
	jump_text.set_text("%s" % int(Global.jump-199))
