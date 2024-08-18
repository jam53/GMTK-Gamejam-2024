extends Node2D

@export var initial_amount: int = 5
@export var spawn_area: ReferenceRect

@export_category("Animals to spawn")
@export var basic_bear: PackedScene
@export var basic_rabbit: PackedScene

var bear_chance: float = 0.2  # Initial chance of spawning a bear

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_animals(initial_amount)
	
	# Start the timer to spawn animals every 5 seconds
	var timer = Timer.new()
	timer.wait_time = 5.0
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	add_child(timer)
	timer.start()

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
		if random_value < bear_chance:
			spawn_animal(basic_bear, pos)
		else:
			spawn_animal(basic_rabbit, pos)

# Called every 5 seconds by the timer
func _on_Timer_timeout():
	generate_animals(1)
	bear_chance = min(bear_chance + 0.1, 1.0)  # Increase bear chance by 0.1, maxing out at 1.0
