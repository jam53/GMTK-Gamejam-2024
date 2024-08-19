extends Node2D

@export var how_to_play_window: Window

func _on_play_button_down():
	get_tree().change_scene("res://scenes/lawn.tscn")

func _on_how_to_play_button_down():
	how_to_play_window.show()

func _on_how_to_play_close_requested():
	how_to_play_window.hide()