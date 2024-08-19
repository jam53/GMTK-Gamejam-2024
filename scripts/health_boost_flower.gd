extends Node2D

class_name HealthBoostFlower

@export var multiplier := 2


func _on_boost_area_body_entered(body):
	if body.get_parent() is Attacker:
		body.get_parent().change_damage_reduction(multiplier)
	

func _on_boost_area_body_exited(body):
	if body.get_parent() is Attacker:
		body.get_parent().change_damage_reduction(1)
