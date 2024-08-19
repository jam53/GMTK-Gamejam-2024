extends Node2D
class_name MoveComponent

@export var speed: float
@export var parent : Node2D
@export var hitbox_component : HitboxComponent

var target_flower: Node = null


func _process(delta):
	if hitbox_component.enemy:
		find_closest_flower()
		if target_flower:
			parent.global_position =  parent.global_position.move_toward(target_flower.global_position, speed * delta)

# Finds the closest flower and sets it as the target
func find_closest_flower():
	var closest_distance = INF
	target_flower = null  # Reset target_flower before finding the closest one
	for flower in get_tree().get_nodes_in_group("flowers"):
		var distance = global_position.distance_to(flower.global_position)
		if distance < closest_distance:
			closest_distance = distance
			target_flower = flower
