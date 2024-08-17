extends Node2D

@export var initial_amount: int = 5
@export var spawn_area: ReferenceRect

@export_category("Flowers to spawn")
@export var basic_flower: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_flowers(basic_flower, initial_amount)

# Generates a random position with the spawn_area
func generate_random_position() -> Vector2:
	var top_left = spawn_area.get_rect().position 
	var bottom_right = spawn_area.get_rect().end 
	return Vector2(randf_range(top_left.x, bottom_right.x), randf_range(bottom_right.y, top_left.y))

# Instantiates a flower at a given position.
func spawn_flower(flower: PackedScene, pos: Vector2) -> Node:
	var flowerInstance := flower.instantiate()
	flowerInstance.position = pos
	add_child(flowerInstance)
	return flowerInstance 

# Generates a specified number of flowers of the given PackedScene type
func generate_flowers(flower: PackedScene, amount := 1):
	for i in range(0, amount):
		var pos = generate_random_position()
		spawn_flower(flower, pos)
