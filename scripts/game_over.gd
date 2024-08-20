extends Window
class_name GameOver

@export var description: RichTextLabel

func _on_close_requested():
	self.hide()

func show_game_over_window(time_survived: int):
	self.show()
	description.text = "Your base hive (green) was destroyed, ending the game.\n\n[b]Time survived: " + format_time(time_survived) + "[/b]"

func format_time(milliseconds: int) -> String:
	var total_seconds = milliseconds / 1000
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	var ms = milliseconds % 1000

	var formatted_time = String("%02d:%02d.%03d" % [minutes, seconds, ms])
	return formatted_time
