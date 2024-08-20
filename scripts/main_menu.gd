extends Node2D

@onready var how_to_play_window: Window = HowToPlay
@export var personal_best_ui_node: Button

func _ready():
	var personal_best := 0
	var file = FileAccess.open("user://HoneyHorizon.dat", FileAccess.READ)
	if file:
		personal_best = int(file.get_as_text())

	personal_best_ui_node.text = "Personal best: " + format_time(personal_best)

func _on_play_button_down():
	get_tree().change_scene_to_file("res://scenes/lawn.tscn")

func _on_how_to_play_button_down():
	how_to_play_window.show()

func format_time(milliseconds: int) -> String:
	var total_seconds = milliseconds / 1000
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	var ms = milliseconds % 1000

	var formatted_time = String("%02d:%02d.%03d" % [minutes, seconds, ms])
	return formatted_time
