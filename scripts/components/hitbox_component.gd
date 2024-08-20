extends Node2D
class_name HitboxComponent

@export var health_component: HealthComponent = null
@export var attack_component: AttackComponent = null
@export var enemy : bool

func take_damage(damage: int) -> void:
	health_component.take_damage(damage)

func attack(target: Node) -> void:
	attack_component.add_target(target)
	
func _is_target(area):
	return (attack_component != null) and area.has_method("take_damage") and (self.enemy != area.enemy)

func _on_area_entered(area):
	if _is_target(area):
		self.attack(area)

func _on_area_exited(area):
	if _is_target(area):
		attack_component.remove_target(area)
