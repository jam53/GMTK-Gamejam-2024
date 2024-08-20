extends CharacterBody2D

class_name Bear

func _on_health_component_died():
	queue_free()
