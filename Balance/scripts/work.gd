extends Node2D


var workday_length: float = 90.0 # How long does the player play for in seconds


@onready var new_item_button = $CanvasLayer/NewItemButton
@onready var workday_timer = $WorkdayTimer

var tray_item_scene = load("res://scenes/tray_item.tscn")
var workday_summary_scene = load("res://scenes/workday_summary.tscn")

var item_spawn_pos: Vector2 = Vector2(330, 100) # Position for items to drop from

var dropped_item_penalty: float = 1.0

var delivered_plates: int = 0 # How many plates the player has delivered
var dropped_plates: int = 0 # How many plates the player has dropped


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the global worked flag to true for game state tracking
	Global.has_worked_today = true
	
	# Set up the workday timer
	if Global.day != 1:
		start_work()
	else:
		new_item_button.visible = false
		Dialogic.start("work1")
	
	# Connect to dialogic
	Dialogic.signal_event.connect(_on_dialogic_event) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Clean up off-screen items and do penalty
	for tray_item in $TrayItems.get_children():
		if tray_item.position.y > 1100:
			dropped_item(tray_item)
	
	# Set time label (probably doesn't need to happen every frame but oh well lol)
	$TimeLabel.text = "TIME REMAINING: " + str("%.1f" % workday_timer.time_left)


func _on_new_item_button_pressed():
	var new_item = tray_item_scene.instantiate()
	# Item id might be necessary if each item has a different value or something
	# But currently it's useless you can just ignore if u want
	var item_id = new_item.get_instance_id()
	
	# Set spawn position
	new_item.position = item_spawn_pos
	# Add to the scene
	$TrayItems.add_child(new_item)


func _on_delivery_zone_body_entered(body):
	if body.is_in_group("tray item"):
		$DeliverMarker.position = body.position
		body.queue_free()
		delivered_item()


func delivered_item():
	# Increment delivered_plates var
	delivered_plates += 1
	# Add a label for showing the money made
	# Oversimplified rn, can improve for final
	var item_value: float = 1.0 # worth one dollar
	var money_label = Label.new()
	money_label.text = "$" + str(item_value)
	money_label.position = $DeliverMarker.position + Vector2(0, -50)
	money_label.add_theme_color_override("font_color", Color("Green"))
	money_label.add_theme_font_size_override("font_size", 24)
	add_child(money_label)
	# Update balance
	Global.balance += item_value
	Global.update_balance.emit()


func dropped_item(item):
	# Increment dropped_plates variable
	dropped_plates += 1
	# Label
	var new_label = Label.new()
	new_label.text = "-$" + str(dropped_item_penalty)
	new_label.position = item.position + Vector2(0, -200)
	new_label.add_theme_color_override("font_color", Color("Red"))
	new_label.add_theme_font_size_override("font_size", 24)
	add_child(new_label)
	# Remove the dropped item
	item.queue_free()
	# Update balance
	if Global.balance >= dropped_item_penalty:
		Global.balance -= dropped_item_penalty
		Global.update_balance.emit()


func work_day_end():
	# Hide the buttons
	new_item_button.visible = false
	
	var workday_summary = workday_summary_scene.instantiate()
	workday_summary.plates_delivered = delivered_plates
	workday_summary.plates_dropped = dropped_plates
	add_child(workday_summary)
	workday_summary.next_button.connect("button_down", _on_next_button_button_down)


func _on_next_button_button_down():
	Global.switch_to_scene("walking")


func _on_workday_timer_timeout():
	work_day_end()


func _on_dialogic_event(argument):
	if argument == "start_work":
		start_work()


func start_work():
	workday_timer.wait_time = workday_length
	workday_timer.start()
	new_item_button.visible = true
