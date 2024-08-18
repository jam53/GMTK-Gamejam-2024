extends Node2D

class_name Attacker

func _on_health_component_died():
	self.queue_free()
