extends Control

# There's probably a way to do this that's better than this but
# I'm just using this script to assign variables for the children
var item_button_text: String
var item_sprite_texture

@onready var item_button = $ItemButton
@onready var item_sprite = $ItemSprite
@onready var item_label = $ItemLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	if item_button_text:
		item_label.text = item_button_text
	
	if item_sprite_texture:
		item_sprite.texture = item_sprite_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
