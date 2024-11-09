extends Node

# Global autoload/singleton script
# Houses global variables to be used by other scenes
# Handles game state changes/scene switching (?)


# Player variables -----------
var mom_wellbeing: int = 80 # Value from 0 to 100 of mental health
var son_wellbeing: int = 80 # Game is lost if either wellbeing drops below 0

var balance: float = 0.0 # MONEY IN DOLLARS (1.0 = $1)

#(removed) var chosen_food: String = "" # Temporary storage for value
#-----------------------------


# Game state variables -------
var day: int = 1 # Starts on day one
var has_worked_today: bool = false # Switches on after working a shift
# Array for the day numbers which bill events occur,
# the names of the bills, and the value in dollars of the bill
var bills: Array = []
var available_shop_items: Array = []

var shopper: String # Person to 'receive' purchased item
#-----------------------------


signal update_balance # For use by balance_card scene to update the label

# Called when the node enters the scene tree for the first time.
func _ready():
	print("GAME STARTED")
	
	if day == 1:
		balance = 50.0 # Start with $50


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func switch_to_scene(scene):
	# Set the scene to be loaded
	var next_scene = load("res://scenes/" + scene + ".tscn")
	# Switch active scene to the next scene
	get_tree().change_scene_to_packed(next_scene)


func check_wellbeing():
	if mom_wellbeing > 100:
		mom_wellbeing = 100
	elif mom_wellbeing < 1:
		game_over()
	
	if son_wellbeing > 100:
		son_wellbeing = 100
	elif son_wellbeing < 1:
		game_over()


func game_over():
	print("Game over")


func shop_for_food(person: String, food_1: String = "empty",\
 food_2: String = "empty", food_3: String = "empty"):
	# Parameters/arguments for this func:
	# person - mom, son, daughter - the person the food is for
	# food_1, food_2, food_3 - food items (strings)
	# food arguments are set to "empty" by default so that they can be optional
	# Since not all shop times have 3 different items
	
	# Pause the dialogue
	Dialogic.paused = true
	
	shopper = person
	
	# Set the shop items
	available_shop_items = [] # Reset
	if food_1 != "empty":
		available_shop_items.append(food_1)
	if food_2 != "empty":
		available_shop_items.append(food_2)
	if food_3 != "empty":
		available_shop_items.append(food_3)
	
	switch_to_scene("shop_menu")


func get_price(item) -> float:
	match item:
		"Omelet":
			return 2.30
		"Cereal":
			return 1.00
		"Salmon":
			return 12.00
		"Cheeseburger":
			return 5.00
		"Grilled Chicken":
			return 6.00
		"Spaghetti":
			return 1.75
		"Ramen":
			return 0.75
		"homeless_man": # shitty workaround for Dialogic lmao
			return -50.00
	
	# Return 100 if the item can't be found
	return 100


func purchase(item):
	var price: float
	# If 'item' is a string, look up its price
	# Else, it's a float and just set price to be 'item'
	# Since 'item' can be used as a raw input payment
	if float(item) == 0:
		price = get_price(item)
	else:
		price = float(item)
	
	# Don't let the player buy something they can't afford
	if balance - price < 0:
		return
	else:
		balance -= price
		update_balance.emit()


func walk_to_work():
	switch_to_scene("walking")


func fall_asleep():
	# Day incrementation happens in the nightly summary scene
	switch_to_scene("nightly_summary")
	# Reset the game state to morning time type shit
	has_worked_today = false


func change_wellbeing(person: String, value, sign: String):
	# This function is mostly just here to be able to update wellbeing straight from
	# Dialogic, since it wasn't working correctly with update specific variables
	# But it doesn't struggle with running functions on autoload scripts
	# ALSO HAVE TO INCLUDE SIGN BC DUMBASS DIALOGIC HAS NEVER HEARD OF NEGATIVE NUMBERS
	if person == "mom":
		if sign == "plus":
			mom_wellbeing += value
		elif sign == "minus":
			mom_wellbeing -= value
	elif person == "son":
		if sign == "plus":
			son_wellbeing += value
		elif sign == "minus":
			son_wellbeing -= value
	
	check_wellbeing() # Makes sure it doesn't go above 100 and lose game if <= 0

