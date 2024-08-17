extends StaticBody2D

class_name Beelure

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			visible = true
			position = event.position
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			visible = false
