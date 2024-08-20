extends StaticBody2D

class_name BasicFlower



func _on_health_component_died():
	queue_free()
