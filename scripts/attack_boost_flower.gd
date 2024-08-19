extends Node2D

class_name AttackBoostFlower

@export var multiplier := 2


func _on_boost_area_body_entered(body):
	if body.get_parent() is Attacker:
		body.get_parent().multiply_attack(2)
	

func _on_boost_area_body_exited(body):
	if body.get_parent() is Attacker:
		body.get_parent().multiply_attack(1)
