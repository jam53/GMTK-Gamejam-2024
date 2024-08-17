extends Node2D

@export var speed: float = 30.0
@export var max_hp: int = 3  # Maximum HP for the bear

var current_hp: int = max_hp  # Current HP of the bear
var target_flower: Node = null
var collision_timer: Timer = null
var is_being_freed: bool = false  # Flag to prevent race conditions
var health_bar: ProgressBar = null  # Health bar for the bear

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initial call to find the closest flower
	find_closest_flower()
	# Initialize the collision timer
	collision_timer = Timer.new()
	collision_timer.wait_time = 5.0
	collision_timer.one_shot = true
	add_child(collision_timer)
	collision_timer.connect("timeout", Callable(self, "_on_collision_timeout"))
	
	# Initialize the health bar
	health_bar = ProgressBar.new()
	health_bar.min_value = 0
	health_bar.max_value = max_hp
	health_bar.value = current_hp
	health_bar.anchor_left = 0.5
	health_bar.anchor_right = 0.5
	health_bar.anchor_top = 0
	health_bar.anchor_bottom = 0
	health_bar.offset_left = -50
	health_bar.offset_right = 50
	health_bar.offset_top = -20
	health_bar.offset_bottom = -10
	add_child(health_bar)

# Finds the closest flower and sets it as the target
func find_closest_flower():
	var closest_distance = INF
	target_flower = null  # Reset target_flower before finding the closest one
	for flower in Global.flowers:
		var distance = position.distance_to(flower.position)
		if distance < closest_distance:
			closest_distance = distance
			target_flower = flower

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Continuously find the closest flower
	find_closest_flower()
	if target_flower:
		self.position = self.position.move_toward(target_flower.position, speed * delta)
		# Check for collision
		if position.distance_to(target_flower.position) < 10:  # Adjust the collision distance as needed
			if collision_timer.is_stopped():
				collision_timer.start()
		else:
			if not collision_timer.is_stopped():
				collision_timer.stop()

# Called when the collision timer times out
func _on_collision_timeout():
	if target_flower:
		Global.flowers.erase(target_flower)
		target_flower.queue_free()
		target_flower = null
		find_closest_flower()

func _on_body_entered(body):
	if body is BoidComponent:
		if not is_being_freed:
			current_hp -= 1
			health_bar.value = current_hp
			if current_hp <= 0:
				is_being_freed = true
				queue_free()
			body.queue_free()