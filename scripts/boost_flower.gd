extends Node2D

class_name BoostFlower

@export var multiplier := 2
@export var boost_type := Enums.BoostType.ATTACK

var boosted : Array[Attacker] = []
var disabled := false

func _process(delta):
	if not disabled and is_in_group("occupied_flowers"):
		disabled = true
		for body in boosted:
			body.remove_boost(self, boost_type)
	elif disabled and not is_in_group("occupied_flowers"):
		disabled = false
		for body in boosted:
			body.add_boost(self, boost_type, multiplier)
	
func _on_boost_area_body_entered(body):
	if body.get_parent() is Attacker:
		if not disabled:
			body.get_parent().add_boost(self, boost_type, multiplier)
		boosted.append(body.get_parent())
	
func _on_boost_area_body_exited(body):
	if body.get_parent() is Attacker:
		body.get_parent().remove_boost(self, boost_type)
		boosted.remove_at(boosted.find(body.get_parent()))

func _on_progress_timer_timer_finsihed():
	for body in boosted:
		body.remove_boost(self, boost_type)
	queue_free()
	
