extends Node2D

@export var initial_amount: int = 5
@export var increment_bear_chance : int = 0.05
@export var boss_wave_wait_time : int = 120
@onready var spawn_area: ReferenceRect = $"../../Player/SpawnArea"

@export_category("Animals to spawn")
@export var basic_bear: PackedScene
@export var basic_rabbit: PackedScene

var bear_chance: float = 0.2  # Initial chance of spawning a bear

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_animals(initial_amount)
	
	# Start the timer to spawn animals every 10 seconds
	var timer = Timer.new()
	timer.wait_time = 10.0
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	add_child(timer)
	timer.start()
	
	# Start the timer to spawn 5 enemies every minute, but only after the first minute
	var minute_timer = Timer.new()
	minute_timer.wait_time = 60.0
	minute_timer.one_shot = true
	minute_timer.connect("timeout", Callable(self, "_start_minute_timer"))
	add_child(minute_timer)
	minute_timer.start()

# Generates a random position on the edge of the spawn_area
func generate_random_position() -> Vector2:
	var top_left = spawn_area.get_rect().position 
	var bottom_right = spawn_area.get_rect().end 
	var edge = randi_range(0, 4)
	match edge:
		0:  # Top edge
			return Vector2(randf_range(top_left.x, bottom_right.x), top_left.y)
		1:  # Bottom edge
			return Vector2(randf_range(top_left.x, bottom_right.x), bottom_right.y)
		2:  # Left edge
			return Vector2(top_left.x, randf_range(top_left.y, bottom_right.y))
		3:  # Right edge
			return Vector2(bottom_right.x, randf_range(top_left.y, bottom_right.y))
		_:
			return Vector2(randf_range(top_left.x, bottom_right.x), top_left.y) 
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

# Called every 10 seconds by the timer
func _on_Timer_timeout():
	generate_animals(1)
	bear_chance = min(bear_chance + increment_bear_chance, 0.5)  # Increase bear chance by 0.1, maxing out at 1.0

# Starts the minute timer to spawn 5 enemies every minute
func _start_minute_timer():
	var minute_timer = Timer.new()
	minute_timer.wait_time = boss_wave_wait_time
	minute_timer.connect("timeout", Callable(self, "_on_MinuteTimer_timeout"))
	add_child(minute_timer)
	minute_timer.start()

# Called every minute by the minute timer
func _on_MinuteTimer_timeout():
	generate_animals(5)
	# Restart the minute timer
	_start_minute_timer()
