extends CharacterBody2D

class_name Dog

func _on_health_component_died():
	queue_free()
