extends Sprite2D

var smiley = load("res://assets/smiley.png")
var frowny = load("res://assets/frowny.png")

@export var person: String = "mom"

var wellbeing: float

# Called when the node enters the scene tree for the first time.
func _ready():
	if person == "mom":
		wellbeing = Global.mom_wellbeing
	elif person == "son":
		wellbeing = Global.son_wellbeing
	
	if wellbeing > 50:
		texture = smiley
	else:
		texture = frowny
	
	# Calculate the proportion (0.0 to 1.0) based on wellbeing
	var proportion = wellbeing / 100.0
	
	# Interpolate between green and red
	# Green (Color(0, 1, 0)) to Red (Color(1, 0, 0))
	var new_color = Color(1 - proportion, proportion, 0)
	
	# Set the modulate color of the Sprite2D
	self_modulate = new_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
