extends Node2D

class_name AttackBoostFlower

@export var multiplier := 2

var boosted : Array[Attacker] = []

	
func _on_boost_area_body_entered(body):
	if body.get_parent() is Attacker:
		body.get_parent().add_attack_boost(self, multiplier)
		boosted.append(body.get_parent())
	

func _on_boost_area_body_exited(body):
	if body.get_parent() is Attacker:
		body.get_parent().remove_attack_boost(self)
		boosted.remove_at(boosted.find(body.get_parent()))


func _on_progress_timer_timer_finsihed():
	for body in boosted:
		body.remove_attack_boost(self)
	queue_free()
	
