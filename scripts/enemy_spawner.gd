extends Node2D

@export var initial_amount: int = 5
@export var spawn_area: ReferenceRect

@export_category("Animals to spawn")
@export var basic_bear: PackedScene
@export var basic_rabbit: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	# Debug information to check if the scenes are assigned
	if basic_bear == null:
		print("Error: basic_bear is not assigned.")
	if basic_rabbit == null:
		print("Error: basic_rabbit is not assigned.")
	
	generate_animals(initial_amount)

# Generates a random position within the spawn_area
func generate_random_position() -> Vector2:
	var top_left = spawn_area.get_rect().position 
	var bottom_right = spawn_area.get_rect().end 
	return Vector2(randf_range(top_left.x, bottom_right.x), randf_range(bottom_right.y, top_left.y))

# Instantiates an animal at a given position.
func spawn_animal(animal: PackedScene, pos: Vector2) -> Node:
	if animal == null:
		print("Error: Trying to instantiate a null animal.")
		return null
	var animal_instance := animal.instantiate()
	animal_instance.position = pos
	add_child(animal_instance)
	return animal_instance 

# Generates a specified number of animals, randomly choosing between bear and rabbit
func generate_animals(amount := 1):
	for i in range(0, amount):
		var pos = generate_random_position()
		var random_value = randf()
		if random_value < 0.8:
			print("Spawning a rabbit.")
			spawn_animal(basic_rabbit, pos)
		else:
			print("Spawning a bear.")
			spawn_animal(basic_bear, pos)
