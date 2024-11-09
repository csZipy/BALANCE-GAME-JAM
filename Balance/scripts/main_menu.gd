extends Node2D

# Scene name to switch into on startup
var first_scene: String = "home"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	Global.switch_to_scene(first_scene)


