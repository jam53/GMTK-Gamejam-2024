extends Node2D

class_name NumberLabel

@onready var label = $HoneyAmountLabel

func set_count(honeycount: int):
	if honeycount >= 1000:
		var formatted_count := "%.1fk" % (honeycount / 1000.0)
		# Remove any unnecessary decimal point if the value is an integer (e.g., 1.0k -> 1k)
		if formatted_count.ends_with(".0k"):
			formatted_count = formatted_count.replace(".0k", "k")
		label.text = formatted_count
	else:
		label.text = str(honeycount)
