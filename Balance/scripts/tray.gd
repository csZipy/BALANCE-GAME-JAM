extends CharacterBody2D


var max_speed = 1000
var acceleration = 1000  # Rate of acceleration in pixels per second squared
var deceleration = 4000  # Rate of deceleration when no input is pressed

# Define the boundaries
var screen_size = Vector2.ZERO  # Will hold the size of the viewport

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size  # Get the size of the viewport


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2.ZERO  # Reset movement direction
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1  # Move right
	
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1  # Move left
	
	# Normalize to handle diagonal movement correctly
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		
		# Check if the current velocity direction is opposite to the new direction
		if direction.dot(velocity.normalized()) < 0:
			# Reset velocity if changing directions
			velocity *= 0.2 #= Vector2.ZERO
		
		# Apply acceleration in the direction of input
		velocity += direction * acceleration * delta
		# Cap the velocity to max speed
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
	else:
		# Apply deceleration when no input is pressed
		if velocity.length() > 0:
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	move_and_slide()
	# Ensure the player stays within the screen boundaries
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

