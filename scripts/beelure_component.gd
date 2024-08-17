extends Node2D

class_name Beelure

@export var capacity := 5
@export var cooldown := 2

var _population := []
var _can_pickup := true
@onready var timer = $Timer

func _ready():
	timer.wait_time = cooldown
	
func _on_body_entered(body):
	print("Hamburger entered and canpickup= %s" % _can_pickup)
	if (
		_can_pickup and
		body is Bee and 
		_population.size() < capacity 
	):
		body.lure = self
		_population.append(body)
		print("Current population size: %d" % _population.size())
		

signal beelure_released()
signal beelure_reactivated()

func release():
	_can_pickup = false
	timer.start()
	for bee in _population:
		bee.lure = null
	_population = []
	beelure_released.emit()
	
	
func _on_timer_timeout():
	_can_pickup = true
	beelure_reactivated.emit()
	
