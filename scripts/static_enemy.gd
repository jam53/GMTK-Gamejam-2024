extends Node2D

@export var showHealtbar: bool = true
@export var max_hp: int # Maximum HP for the bear
@export var attack: int = 1  # Attack damage of the bear

var current_hp: int  # Current HP of the bear
var target_flower: Node = null
var collision_timer: Timer = null
var is_being_freed: bool = false  # Flag to prevent race conditions
var health_bar: ProgressBar = null  # Health bar for the bear

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initial call to find the closest flower
	# Initialize the collision timer
	collision_timer = Timer.new()
	collision_timer.wait_time = 5.0
	collision_timer.one_shot = true
	add_child(collision_timer)
	collision_timer.connect("timeout", Callable(self, "_on_collision_timeout"))
	current_hp = max_hp
	
	# Initialize the health bar
	if showHealtbar:
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body is BoidComponent and body.beetype == Enums.BeeType.BEE:
		if not is_being_freed:
			current_hp -= 1
			if showHealtbar:
				health_bar.value = current_hp
			if current_hp <= 0:
				body.remove_from_group("bees")
				is_being_freed = true
				if showHealtbar:
					health_bar.queue_free()
				queue_free()
			body.hp -= attack
