extends Node2D

class_name Attacker

@onready var attack_component = $BoidsComponent/AttackComponent
@onready var shadow_sprite = $BoidsComponent/Sprites/ShadowSprite


var hive : AttackHive

func multiply_attack(multiplier: int):
	attack_component.attack_multiplier = multiplier

func _on_health_component_died():
	if hive != null:
		hive.bee_died()
	self.queue_free()


func _on_attack_component_multiplier_changed(multiplier):
	if multiplier > 1:
		shadow_sprite.visible = true
	else:
		shadow_sprite.visible = false
