extends CharacterBody2D

@export var game_over_window: GameOver

var time_start: int
var time_survived: int = -1

func _ready():
	time_start = Time.get_ticks_msec()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		update_personal_best()
		get_tree().quit() # default behavior, closes the game

func _on_health_component_died():
	game_over_window.show_game_over_window(get_time_survived())
	get_tree().root.add_child(game_over_window.duplicate())
	update_personal_best()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func update_personal_best():
	if get_time_survived() > get_personal_best_from_disk():
		save_personal_best_to_disk(time_survived)

func get_time_survived() -> int:
	if time_survived == -1:
		time_survived = Time.get_ticks_msec() - time_start

	return time_survived

func get_personal_best_from_disk() -> int:
	var personal_best: int = 0

	var file = FileAccess.open("user://HoneyHorizon.dat", FileAccess.READ)
	if file:
		personal_best = int(file.get_as_text())

	return personal_best

func save_personal_best_to_disk(personal_best: int):
	var file = FileAccess.open("user://HoneyHorizon.dat", FileAccess.WRITE)
	file.store_string(str(personal_best))
