extends Area2D



	
@onready var beelure_component = $BeelureComponent
@onready var polygon_2d = $Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			visible = true
			position = event.position
		
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("Hamburger clicked")
			beelure_component.release()


func _on_beelure_reactivated():
	polygon_2d.visible = true

func _on_beelure_released():
	polygon_2d.visible = false
	
