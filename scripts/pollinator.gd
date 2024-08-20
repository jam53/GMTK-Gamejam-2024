extends Node2D

@export var hive : Hive
@export var pollinateTime := 2
@export var hiveTime := 2
@onready var boids_component = $BoidsComponent
@onready var pollinate_timer = $PollinateTimer
@onready var hive_timer = $HiveTimer

var basic_flower = preload("res://scenes/flowers/basic_flower.tscn")

var new_flower_chance : float = 0.3
var _flower_found := false
var _in_hive := false
var found_flower_location : Vector2
var found_flower_parent : Node
var found_flower : Node

func _ready():
	pollinate_timer.wait_time = pollinateTime
	hive_timer.wait_time = hiveTime

func _process(delta):
	if not _in_hive and (boids_component.lure == null or (not _flower_found and boids_component.lure == hive)):
		print("finding new flower")
		found_flower = find_flower()
		
		if found_flower == null:
			boids_component.lure = hive
		else:
			found_flower_location = found_flower.global_position
			found_flower_parent = found_flower.get_parent()
			boids_component.lure = found_flower
	
	if is_instance_valid(found_flower) and found_flower.is_in_group("occupied_flowers"):
		boids_component.lure = null
	
	

func find_flower() -> Node2D:
	var flowers = get_tree().get_nodes_in_group("flowers")
	var available_flowers = []
	
	for flower in flowers:
		if not flower.is_in_group("occupied_flowers"):
			available_flowers.append(flower)
		
	if available_flowers.size() == 0:
		return null
	
	return available_flowers.pick_random()


func _on_flower_detection_area_area_entered(area):
	if area.get_parent() == boids_component.lure and not _flower_found:
		print("flower found")
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
	
	if found_flower_location != null and found_flower_parent != null:
		if randf() < new_flower_chance:
			# Create a new basic_flower instance
			var new_flower = basic_flower.instantiate()
			
			# Set the position of the new flower close to the found_flower
			var offset = Vector2(randf() * 500 - 250, randf() * 500 - 250)  # Random offset within a 20x20 area
			new_flower.position = found_flower_location + offset
			
			# Add the new flower as a child to the parent of found_flower
			found_flower_parent.add_child(new_flower)


func _on_hive_timer_timeout():
	_in_hive = false
	boids_component.lure = null
