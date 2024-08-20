extends CharacterBody2D


class_name Rabbit

func _on_health_component_died():
	queue_free()
