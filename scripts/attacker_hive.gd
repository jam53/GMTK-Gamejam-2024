extends StaticBody2D

class_name AttackHive

@export var capacity := 5
@export var respawns := 5
@export var respawntime: float = 5

@onready var timertext = $Timerlabel
@onready var respawntext = $Respawnlabel


var attacker_template = preload("res://scenes/bees/attacker.tscn")
var active_timers: Array = []

func _ready():
	timertext.text = ""
	set_respawntext()
	for i in range(capacity):
		_spawn_bee(false)
	
func set_respawntext():
	respawntext.text = str(respawns) + " respawns"
	
func bee_died():
	# Create new timer
	var new_timer = Timer.new()
	new_timer.wait_time = respawntime
	new_timer.one_shot = true
	new_timer.timeout.connect(_on_timer_timeout)
	add_child(new_timer)
	new_timer.start()
	
	# Add the new timer to the list of active timers
	active_timers.append(new_timer)

func _on_timer_timeout():
	# Spawn a new bee

	_spawn_bee()

	# Remove expired timers from the active timers list
	active_timers = active_timers.filter(func(timer):
		return timer.is_stopped() == false
	)
	
func die():
	for child in get_children():
		if child is Attacker:
			var global_pos = child.global_position
			child.hive = null
			remove_child(child)
			get_parent().add_child(child)
				
			child.global_position = global_pos
		queue_free()

func _spawn_bee(consume_respawn: bool = true):
	if consume_respawn:
		respawns -= 1
		set_respawntext()
	
	var attacker = attacker_template.instantiate()
	attacker.hive = self
	add_child(attacker)
	
	if respawns == 0:
		die()

func _process(delta):
	if active_timers.size() > 0:
		# Find the timer with the least time left
		var shortest_time = active_timers[0].time_left
		for timer in active_timers:
			if timer.time_left < shortest_time:
				shortest_time = timer.time_left

		# Update the label with the shortest remaining time
		timertext.text = "Respawning in: %.2f" % shortest_time
	else:
		timertext.text = ""


func _on_health_component_died():
	die()
