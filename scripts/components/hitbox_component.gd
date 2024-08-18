extends Node2D
class_name HitboxComponent

@export var health_component: HealthComponent = null
@export var attack_component: AttackComponent = null
@export var enemy : bool

func take_damage(damage: int) -> void:
	health_component.take_damage(damage)

func attack(target: Node) -> void:
	attack_component.damage(target)

func _on_area_entered(area):
	if (attack_component != null) and area.has_method("take_damage") and (self.enemy != area.enemy):
		self.attack(area)
