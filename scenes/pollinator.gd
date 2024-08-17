extends Node2D

@export var hive : Node2D
@export var pollinateTime := 2
@export var hiveTime := 2
@onready var boids_component = $BoidsComponent
@onready var pollinate_timer = $PollinateTimer
@onready var hive_timer = $HiveTimer
@onready var game_manager = %GameManager

var _flower_found := false
var _in_hive := false

func _ready():
	pollinate_timer.wait_time = pollinateTime
	hive_timer.wait_time = hiveTime

func _process(delta):
	if not _in_hive and boids_component.lure == null:
		boids_component.lure = find_flower()

func find_flower() -> Node2D:
	var flowers = get_tree().get_nodes_in_group("flowers")
	
	if flowers.size() == 0:
		return null
	
	return flowers.pick_random()

func _on_flower_detection_area_area_entered(area):
	if area.get_parent() == boids_component.lure and not _flower_found:
		_flower_found = true
		print("Flower found")
		pollinate_timer.start()


func _on_flower_detection_area_body_entered(body):
	if body == hive and not _in_hive and _flower_found:
		print("Hive found")
		_flower_found = false
		_in_hive = true
		hive_timer.start()

func _on_pollinate_timer_timeout():
	print("Flower pollinated")
	boids_component.lure = hive

func _on_hive_timer_timeout():
	print("Hivetime finished")
	game_manager.update_honey(5)
	_in_hive = false
	boids_component.lure = null
