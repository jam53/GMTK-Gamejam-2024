extends Node2D

class_name NumberLabel

@onready var label = $HoneyAmountLabel

func set_count(honeycount: int):
	var font_size: int
	
	if honeycount >= 1000:
		var formatted_count := "%.1fk" % (honeycount / 1000.0)
		# Remove any unnecessary decimal point if the value is an integer (e.g., 1.0k -> 1k)
		label.text = formatted_count
		font_size = 24
	else:
		label.text = str(honeycount)
		font_size = 49 if honeycount < 100 else 40

	# Adjust the font size using theme override
	label.add_theme_font_size_override("font_size", font_size)
