# FlowerScript.gd
extends Node2D

@export var initial_amount: int = 5
@export var spawn_area: ReferenceRect

@export_category("Flowers to spawn")
@export var bee_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	if bee_scene:
		generate_flowers(bee_scene, initial_amount)


# Generates a random position within the spawn_area
func generate_random_position() -> Vector2:
	var top_left = spawn_area.get_rect().position 
	var bottom_right = spawn_area.get_rect().end 
	return Vector2(randf_range(top_left.x, bottom_right.x), randf_range(bottom_right.y, top_left.y))

# Instantiates a flower at a given position.
func spawn_flower(bee: PackedScene, pos: Vector2) -> Node:
	if bee:
		var beeInstance = bee.instantiate()
		beeInstance.position = pos
		add_child(beeInstance)
		beeInstance.add_to_group("bees")
		return beeInstance
	else:
		return null

# Generates a specified number of flowers of the given PackedScene type
func generate_flowers(bee: PackedScene, amount := 1):
	for i in range(0, amount):
		var pos = generate_random_position()
		spawn_flower(bee, pos)
