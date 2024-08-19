extends Node2D

class_name AttackBoostFlower

@export var multiplier := 2

var boosted : Array[Attacker] = []

	
func _on_boost_area_body_entered(body):
	if body.get_parent() is Attacker:
		body.get_parent().multiply_attack(2)
		boosted.append(body)
	

func _on_boost_area_body_exited(body):
	if body.get_parent() is Attacker:
		body.get_parent().multiply_attack(1)
		boosted.remove_at(boosted.find(body))


func _on_progress_timer_timer_finsihed():
	for body in boosted:
		body.multiply_attack(1)
	queue_free()
	
