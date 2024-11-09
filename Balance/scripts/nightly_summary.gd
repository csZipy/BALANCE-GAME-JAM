extends Node2D

@onready var day_label = $DynamicShit/DayLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	update_labels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_labels():
	day_label.text = "DAY\n" + str(Global.day)


func _on_next_button_pressed():
	Global.day += 1
	update_labels()
	$DynamicShit/NextButton.visible = false
	await get_tree().create_timer(0.4).timeout
	Global.switch_to_scene("home")
