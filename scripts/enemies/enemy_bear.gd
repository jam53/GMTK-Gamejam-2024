extends CharacterBody2D

class_name Bear
@onready var musicplayer = $AudioStreamPlayer

func _on_health_component_died():
	if musicplayer:
		musicplayer.play()
	await get_tree().create_timer(0.1).timeout
	queue_free()
