extends Node2D

class_name HealthBoostFlower

@export var multiplier := 2

var boosted : Array[Attacker] = []


func _on_boost_area_body_entered(body):
	if body.get_parent() is Attacker:
		body.get_parent().change_damage_reduction(multiplier)
	

func _on_boost_area_body_exited(body):
	if body.get_parent() is Attacker:
		body.get_parent().change_damage_reduction(1)
		

func _on_progress_timer_timer_finsihed():
	for body in boosted:
		body.multiply_attack(1)
	queue_free()
