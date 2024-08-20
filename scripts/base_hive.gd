extends CharacterBody2D

var time_start: int

func _ready():
	time_start = Time.get_ticks_msec()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		update_personal_best()
		get_tree().quit() # default behavior, closes the game

func _on_health_component_died():
	update_personal_best()
	queue_free()

func update_personal_best():
	var time_survived = get_time_survived()
	if time_survived > get_personal_best_from_disk():
		save_personal_best_to_disk(time_survived)

func get_time_survived() -> int:
	return Time.get_ticks_msec() - time_start

func get_personal_best_from_disk() -> int:
	var personal_best: int = 0

	var file = FileAccess.open("user://HoneyHorizon.dat", FileAccess.READ)
	if file:
		personal_best = int(file.get_as_text())

	return personal_best

func save_personal_best_to_disk(personal_best: int):
	var file = FileAccess.open("user://HoneyHorizon.dat", FileAccess.WRITE)
	file.store_string(str(personal_best))