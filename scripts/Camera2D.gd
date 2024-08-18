extends Camera2D


@export var camera_speed: float = 1000.0 # Speed at which the camera moves
@export var margin: int = 25 # Margin for detecting when the mouse is out of bounds

func _process(delta: float) -> void:
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

    global_position = global_position.lerp(target_position, 0.5)
