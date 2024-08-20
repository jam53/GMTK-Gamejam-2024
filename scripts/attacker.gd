extends Node2D

class_name Attacker

@onready var shadow_sprite = $BoidsComponent/Sprites/ShadowSprite
@onready var health_component = $BoidsComponent/HealthComponent
@onready var attack_component = $BoidsComponent/AttackComponent


var hive : AttackHive

var attack_boosts_active := {}
var health_boosts_active := {}

func _process(delta):
	if attack_boosts_active.size() > 0:
		shadow_sprite.modulate = Color(1, 0, 0)
		shadow_sprite.visible = true
	elif health_boosts_active.size() > 0:
		shadow_sprite.modulate = Color("00ffff")
		shadow_sprite.visible = true
	else:
		shadow_sprite.visible = false
		
func _find_max_in_dict(dict):
	var max = 1
	for key in dict.keys():
		if dict[key] > max:
			max = dict[key]
	return max

func add_attack_boost(source: Node, multiplier: int):
	attack_boosts_active[source] = multiplier
	print(attack_component, attack_boosts_active)
	attack_component.attack_multiplier = _find_max_in_dict(attack_boosts_active)
	

func remove_attack_boost(source: Node):
	attack_boosts_active.erase(source)
	attack_component.attack_multiplier = _find_max_in_dict(attack_boosts_active)


func add_damage_reduction(source: Node, reduction: int):
	health_boosts_active[source] = reduction
	health_component.damage_reduction = _find_max_in_dict(health_boosts_active)

func remove_damage_reduction(source: Node):
	health_boosts_active.erase(source)
	health_component.damage_reduction = _find_max_in_dict(health_boosts_active)

func _on_health_component_died():
	if hive != null:
		hive.bee_died()
	self.queue_free()



	
