extends Node2D
class_name HitboxComponent

@export var health_component: HealthComponent
@export var attack_component: AttackComponent
@export var enemy : bool

func take_damage(damage: int) -> void:
	health_component.take_damage(damage)

func attack(target: Node) -> void:
	attack_component.damage(target)

func on_body_entered(body: Node) -> void:
	print(
		"HitboxComponent: ", self, " collided with ", body
	)
	if body.has_method("attack") and (body as HitboxComponent).enemy != enemy:
		body.attack(self)
