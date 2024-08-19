extends Node2D

@export var how_to_play_window: Window
@export var personal_best_ui_node: Button

func _ready():
	var personal_best := "Personal best: "
	var file = FileAccess.open("user://HoneyHorizon.dat", FileAccess.READ)
	if file:
		personal_best += file.get_as_text()
	else:
		personal_best += "00:00.00"

	personal_best_ui_node.text = personal_best

func _on_play_button_down():
	get_tree().change_scene_to_file("res://scenes/lawn.tscn")

func _on_how_to_play_button_down():
	how_to_play_window.show()

func _on_how_to_play_close_requested():
	how_to_play_window.hide()