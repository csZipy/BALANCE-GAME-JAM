extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	update_label()
	Global.update_balance.connect(update_label)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_label():
	$Label.text = "BALANCE: $" + str("%.2f" % Global.balance)
