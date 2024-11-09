extends Node2D


@onready var item_container = $CanvasLayer/ItemContainer
@onready var shopper_label = $ShopperLabel

var item_panel_scene: PackedScene = load("res://scenes/item_panel.tscn")

# Available items for the player to buy at the moment
var available_items: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Import Global singleton's available items
	if Global.available_shop_items.size() > 0:
		available_items.append_array(Global.available_shop_items)
	
	# Create buttons for each item to buy
	for item in available_items:
		# Item panel is a control scene used to lay out the item elements
		var item_panel = item_panel_scene.instantiate()
		
		# Set up the item panel
		# Sets item name, gets the price, the formatting is weird idk it works
		item_panel.item_button_text = str(item) + "\n$" + str("%.2f" % Global.get_price(item))
		item_panel.item_sprite_texture = load("res://icon.svg") # Placeholder
		# Add the item panel to the HBoxContainer
		item_container.add_child(item_panel)
		item_panel.item_button.connect("button_down", _on_item_button_button_down.bind(item))
	
	# Set the shopper label
	update_shopper_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_item_button_button_down(item):
	print(item)
	if Global.balance > Global.get_price(item):
		Global.purchase(item)
		
		# Turn off the buttons so player can't buy more than one item
		for item_panel in item_container.get_children():
			item_panel.item_button.disabled = true
		
		Dialogic.VAR.chosen_food = item
		Dialogic.paused = false


func _on_nothing_button_pressed():
	Dialogic.VAR.chosen_food = ""
	Dialogic.paused = false


func update_shopper_label():
	# Makes the current shopper's name all caps
	shopper_label.text = "Currently shopping for:\n" + Global.shopper.to_upper()
