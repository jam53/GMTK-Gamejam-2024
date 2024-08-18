extends Node2D
class_name AttackComponent

@export var attack: int

func damage(target: Node) -> void:
	if target.has_method("take_damage"):
		target.take_damage(attack)

