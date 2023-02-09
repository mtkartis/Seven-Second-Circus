extends MarginContainer
#var
export var index = int()
#obj
onready var text = $Text
onready var timer = $Timer
#-----------------START---------------
func _ready():
	text.set_text(Global.tutorial_dict[index])
	
func done():
	queue_free()
