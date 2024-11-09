extends Node2D

@onready var delivered_label = $VariableElements/DeliveredLabel
@onready var dropped_label = $VariableElements/DroppedLabel
@onready var total_label = $VariableElements/TotalLabel
@onready var next_button = $VariableElements/NextButton

var plates_delivered: int = 0

var plates_dropped: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	update_labels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_labels():
	var item_value: float = 1.0
	var delivered_subtotal = item_value * plates_delivered
	
	var penalty_value: float = 1.0
	var dropped_subtotal = penalty_value * plates_dropped
	
	delivered_label.text = str(plates_delivered) + " x $" + str(item_value)\
	+ " = $" + str(delivered_subtotal)
	
	dropped_label.text = str(plates_dropped) + " x -$" + str(penalty_value)\
	+ " = -$" + str(dropped_subtotal)
	
	var total_earned: float = delivered_subtotal - dropped_subtotal
	# Don't let it go into negatives
	if total_earned < 0:
		total_earned = 0
	
	total_label.text = "TOTAL EARNED: $" + str(total_earned)
