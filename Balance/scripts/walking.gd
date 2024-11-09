extends Node2D

@onready var background = $Background
@onready var homeless_guy = $HomelessGuy

# Called when the node enters the scene tree for the first time.
func _ready():
	# Change bg if coming back from work
	if Global.has_worked_today:
		background.flip_h = false
		background.position.x -= 760.0
		homeless_guy.position.x = 1437.0
	
	# Wait a moment before resuming dialogue
	await get_tree().create_timer(1.0).timeout
	start_dialogue()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start_dialogue():
	var timeline: String
	if not Global.has_worked_today: # If the player hasn't worked yet today
		timeline = "walk_to_work" + str(Global.day) # EX day one = walk_to_work1
	else:
		timeline = "walk_home" + str(Global.day)
	
	Dialogic.start(timeline)
