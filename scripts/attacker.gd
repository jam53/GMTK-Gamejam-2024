extends Node2D

class_name Attacker


var hive : AttackHive

func _on_health_component_died():
	if hive != null:
		hive.bee_died()
	self.queue_free()
