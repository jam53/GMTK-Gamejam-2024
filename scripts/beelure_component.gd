extends Node2D

class_name Beelure

# Amount of bees that can be attracted to this lure at a time
@export var capacity := 5
# Time after release where bees won't be attracted
@export var cooldown := 2
# Type of bee it attracts
@export var beetype : Enums.BeeType

var _population := []
var _can_pickup := true
@onready var timer = $Timer

func _ready():
	# Initialize timer
	timer.wait_time = cooldown
	
func _on_body_entered(body):	
	if (
		_can_pickup and # Not on cooldown
		body is BoidComponent and 
		body.beetype == beetype and
		_population.size() < capacity
	):
		if body.lure == null: # Make sure bee isn't attracted to something else
			body.lure = self
			_population.append(body)
			print("Current population size: %d" % _population.size())
		

# Signal on release
signal beelure_released()
# Signal after release cooldown
signal beelure_reactivated()

func release():
	# Disable 
	_can_pickup = false
	timer.start()
	
	# Reset bee goal
	for bee in _population:
		bee.lure = null
		
	# Reset population
	_population = []
	
	beelure_released.emit()
	
	
func _on_timer_timeout():
	# Enable
	_can_pickup = true
	beelure_reactivated.emit()
	
