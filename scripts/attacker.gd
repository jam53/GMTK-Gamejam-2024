extends Node2D

class_name Attacker

@onready var attack_component = $BoidsComponent/AttackComponent
@onready var shadow_sprite = $BoidsComponent/Sprites/ShadowSprite
@onready var health_component = $BoidsComponent/HealthComponent


var hive : AttackHive

func multiply_attack(multiplier: int):
	attack_component.attack_multiplier = multiplier
	if multiplier > 1:
		shadow_sprite.modulate = Color(1, 0, 0)
		shadow_sprite.visible = true
	else:
		shadow_sprite.visible = false

func change_damage_reduction(reduction: int):
	health_component.damage_reduction = reduction
	if reduction > 1:
		shadow_sprite.modulate = Color("00ffff")
		shadow_sprite.visible = true
	else:
		shadow_sprite.visible = false

func _on_health_component_died():
	if hive != null:
		hive.bee_died()
	self.queue_free()



	
