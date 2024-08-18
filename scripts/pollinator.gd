extends Node2D

@export var hive : Hive
@export var pollinateTime := 2
@export var hiveTime := 2
@onready var boids_component = $BoidsComponent
@onready var pollinate_timer = $PollinateTimer
@onready var hive_timer = $HiveTimer


var _flower_found := false
var _in_hive := false

func _ready():
	pollinate_timer.wait_time = pollinateTime
	hive_timer.wait_time = hiveTime

func _process(delta):
	if not _in_hive and boids_component.lure == null:
		var found_flower = find_flower()
		if found_flower == null:
			boids_component.lure = hive
		else:
			boids_component.lure = find_flower()

func find_flower() -> Node2D:
	var flowers = get_tree().get_nodes_in_group("flowers")
	
	if flowers.size() == 0:
		return null
	
	return flowers.pick_random()

func _on_flower_detection_area_area_entered(area):
	if area.get_parent() == boids_component.lure and not _flower_found:
		_flower_found = true
		pollinate_timer.start()


func _on_flower_detection_area_body_entered(body):
	if body == hive and not _in_hive and _flower_found:
		_flower_found = false
		_in_hive = true
		hive.bee_arrived()
		hive_timer.start()

func _on_pollinate_timer_timeout():
	boids_component.lure = hive

func _on_hive_timer_timeout():
	_in_hive = false
	boids_component.lure = null
