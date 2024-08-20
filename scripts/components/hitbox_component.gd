extends Node2D
class_name HitboxComponent

@export var attack_component: AttackComponent = null

func attack(target: Node) -> void:
	attack_component.add_target(target)
	
func stop_attack(target: Node) -> void:
	attack_component.remove_target(target)
	
func _is_target(body) -> bool:
	if get_parent().is_in_group("enemies") and body.is_in_group("enemies"):
		return false
	elif get_parent().is_in_group("attackers") and not body.is_in_group("enemies"):
		return false
	return true
	
func _find_health_component(body) -> HealthComponent:
	if attack_component == null or body == get_parent() or not _is_target(body):
		return null
	else:
		for child in body.get_children():
			if child is HealthComponent:
				return child
	
	return null

func _on_body_entered(body):
	var health_component = _find_health_component(body)
	if health_component != null:
		attack(health_component)

func _on_body_exited(body):
	var health_component = _find_health_component(body)
	if health_component != null:
		stop_attack(health_component)
