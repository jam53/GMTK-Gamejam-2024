extends Node2D
class_name MoveComponent

@export var speed: float
@export var parent : Node2D
@export var hitbox_component : HitboxComponent
@export var attack_component : AttackComponent

enum TargetType { FLOWER, HIVE }
@export var target: TargetType = TargetType.FLOWER

var target_flower: Node = null:
	set(value):
		target_flower = value
		if attack_component != null:
			attack_component.main_target = value

func _process(delta):
	find_closest_flower(target)
	if target_flower:
		parent.global_position =  parent.global_position.move_toward(target_flower.global_position, speed * delta)

# Finds the closest flower and sets it as the target
func find_closest_flower(targetGroup: TargetType):
	var closest_distance = INF
	target_flower = null  # Reset target_flower before finding the closest one
	for flower in get_tree().get_nodes_in_group(enum_to_str(targetGroup)):
		var distance = global_position.distance_to(flower.global_position)
		if distance < closest_distance:
			closest_distance = distance
			target_flower = flower
			
func enum_to_str(targetGroup: TargetType):
	if targetGroup == TargetType.FLOWER:
		return "flowers"
	else:
		return "hives"
