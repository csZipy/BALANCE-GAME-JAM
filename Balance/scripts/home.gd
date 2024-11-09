extends Node2D

@onready var background = $Background



# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the background image based on time of day
	if Global.has_worked_today:
		background.texture = load("res://assets/living_room_night.png")
	
	# Connect the dialogue signals from Dialogic plugin
	# for dialogue event handling
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	# Set the timeline (dialogue tree) based on game state
	var timeline: String
	
	if Global.has_worked_today:
		timeline = "night" + str(Global.day)
	else:
		timeline = "morning" + str(Global.day)
	
	Dialogic.start(timeline)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_dialogic_signal(argument: String):
	match argument:
		"buy_food_mom":
			Global.shop_for_food("mom")
