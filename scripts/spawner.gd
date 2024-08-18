# FlowerScript.gd
extends Node2D

@export var initial_amount: int = 5
@export var spawn_area: ReferenceRect

@export_category("Items to spawn")
@export var scene: PackedScene
@export var group: String

# Called when the node enters the scene tree for the first time.
func _ready():
	if scene:
		generate_items(scene, initial_amount)

# Generates a random position within the spawn_area
func generate_random_position() -> Vector2:
	var top_left = spawn_area.get_rect().position 
	var bottom_right = spawn_area.get_rect().end 
	return Vector2(randf_range(top_left.x, bottom_right.x), randf_range(bottom_right.y, top_left.y))

# Instantiates a flower at a given position.
func spawn_item(flower: PackedScene, pos: Vector2) -> Node:
	if flower:
		var instance = flower.instantiate()
		instance.position = pos
		add_child(instance)
		add_to_group(group)
		return instance
	else:
		return null

# Generates a specified number of flowers of the given PackedScene type
func generate_items(flower: PackedScene, amount := 1):
	for i in range(0, amount):
		var pos = generate_random_position()
		spawn_item(flower, pos)
