extends Node2D
class_name InfoComponent

@export var info_text : String
@export var hitboxComponent : Area2D

@onready var info_label : RichTextLabel = $Label 

func _ready():
	if hitboxComponent and info_label:
		hitboxComponent.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
		hitboxComponent.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
func _on_mouse_entered():
	if info_label:
		info_label.bbcode_text = process_text(info_text)
		info_label.visible = true

func _on_mouse_exited():
	if info_label:
		info_label.visible = false
		
func process_text(text: String) -> String:
	# Replace \n with actual newline
	text = text.replace("\\n", "\n")
	# Add color, bold, and outline to the text
	text = "[color=black]" + text + "[/color]"
	return text
