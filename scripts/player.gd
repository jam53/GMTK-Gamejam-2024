extends CharacterBody2D
## This script is used to control and move the camera around in the play area

@export var camera_speed: float = 500 # Speed at which the camera moves 
@export var margin: int = 25 # Margin for detecting when the mouse is out of bounds
var enable_camera_movement_with_cursor: bool = true

# Used to move the camera using the cursor
func _process(delta: float) -> void:
	if enable_camera_movement_with_cursor:
		var mouse_pos: Vector2 = get_viewport().get_mouse_position() # Get the mouse position relative to the viewport

		var screen_size: Vector2 = get_viewport().get_visible_rect().size

		var target_position: Vector2 = global_position

		# Check if the mouse is outside the bounds of the screen
		if mouse_pos.x < margin:
			target_position.x -= camera_speed * delta
		elif mouse_pos.x > screen_size.x - margin:
			target_position.x += camera_speed * delta

		if mouse_pos.y < margin:
			target_position.y -= camera_speed * delta
		elif mouse_pos.y > screen_size.y - margin:
			target_position.y += camera_speed * delta

		global_position = global_position.lerp(target_position, 1)

# Used to move the camera using the keyboard
func get_input():
	var input_direction := Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * camera_speed
	
	if Input.is_action_just_pressed("toggle_camera_cursor_movement"):
		enable_camera_movement_with_cursor = !enable_camera_movement_with_cursor

func _physics_process(delta):
	get_input()
	move_and_slide()
