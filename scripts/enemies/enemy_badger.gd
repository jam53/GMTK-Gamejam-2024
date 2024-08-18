extends CharacterBody2D

func _on_health_component_died():
	queue_free()
