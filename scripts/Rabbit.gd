extends Node2D

@export var speed: float = 100.0

var target_flower: Node = null
var collision_timer: Timer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initial call to find the closest flower
	find_closest_flower()
	# Initialize the collision timer
	collision_timer = Timer.new()
	collision_timer.wait_time = 10.0
	collision_timer.one_shot = true
	add_child(collision_timer)
	collision_timer.connect("timeout", Callable(self, "_on_collision_timeout"))

# Finds the closest flower and sets it as the target
func find_closest_flower():
	var closest_distance = INF
	target_flower = null  # Reset target_flower before finding the closest one
	for flower in Global.flowers:
		var distance = position.distance_to(flower.position)
		if distance < closest_distance:
			closest_distance = distance
			target_flower = flower
	if target_flower:
		print("Closest flower found at position: ", target_flower.position)
	else:
		print("No flowers found.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Continuously find the closest flower
	find_closest_flower()
	if target_flower:
		self.position = self.position.move_toward(target_flower.position, speed * delta)
		print("Bear position: ", position)
		print("Target flower position: ", target_flower.position)
		print("Distance to target: ", position.distance_to(target_flower.position))
		# Check for collision
		if position.distance_to(target_flower.position) < 10:  # Adjust the collision distance as needed
			print("Bear is close to the flower.")
			if collision_timer.is_stopped():
				print("Starting collision timer.")
				collision_timer.start()
		else:
			if not collision_timer.is_stopped():
				print("Stopping collision timer.")
				collision_timer.stop()
	else:
		print("No target flower to move towards.")

# Called when the collision timer times out
func _on_collision_timeout():
	if target_flower:
		print("Removing flower at position: ", target_flower.position)
		Global.flowers.erase(target_flower)
		target_flower.queue_free()
		target_flower = null
		find_closest_flower()
	else:
		print("No target flower to remove.")
