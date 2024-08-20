# https://github.com/kyrick/godot-boids/tree/master
extends CharacterBody2D

class_name BoidComponent

@onready var flock_area = $FlockArea
@export var sprite : Node2D
@export var flock_area_shape : CollisionShape2D

@export var max_speed: = 500.0
@export var target_follow_force: = 0.05
@export var cohesion_force: = 0.05
@export var align_force: = 0.05
@export var separation_force: = 0.05
@export var view_distance := 50.0
@export var avoid_distance := 20.0

@export var lure : Node2D = null
@export var stopable := false

@export var facing_right := true

var _flock: Array = []
var _velocity: Vector2
var _stop_lure: Node2D
var parent_node: Node2D

func _ready():
	randomize()
	_stop_lure = Node2D.new()
	_velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * max_speed
	parent_node = self.get_parent()  # Reference to the parent node
	assert(parent_node is PhysicsBody2D, "Parent node of BoidsComponent should be PhysicsBody2D")
	parent_node.velocity = velocity
	
	if flock_area_shape.get_parent() != null:
		flock_area_shape.get_parent().remove_child(flock_area_shape)

	flock_area.add_child(flock_area_shape)

func _process(_delta):
	if stopable:
		if lure == null and not GameManager.get_mouse_follow():
			lure = _stop_lure
			lure.position = self.global_position
		elif lure != null and GameManager.get_mouse_follow():
			lure = null
			
func flip_sprites():
	for child in sprite.get_children():
		if child is Sprite2D:
			child.flip_h = not child.flip_h

func _physics_process(_delta):
	var target
	var target_force = target_follow_force
	
	if not is_instance_valid(lure):
		lure = null
	
	if lure is Node2D:
		target = lure.global_position
		target_force *= 2
	else:
		target = get_global_mouse_position()	
		
	var target_vector = Vector2.ZERO
	if target != Vector2.INF:
		target_vector = global_position.direction_to(target) * max_speed * target_force
		
		var cross = target.x - self.global_position.x
		if cross > 0:
			if not facing_right: 
				flip_sprites()
				facing_right = true
		elif cross < 0:
			if facing_right:
				flip_sprites()
				facing_right = false
		
	# Get cohesion, alignment, and separation vectors
	var vectors = get_flock_status(_flock)
	
	# Steer towards vectors
	var cohesion_vector = vectors[0] * cohesion_force
	var align_vector = vectors[1] * align_force
	var separation_vector = vectors[2] * separation_force
	
	# Calculate total acceleration
	var acceleration = cohesion_vector + align_vector + separation_vector + target_vector
	_velocity = (_velocity + acceleration).limit_length(max_speed)
	
	# Update physics values
	
	if parent_node is PhysicsBody2D:
		parent_node.velocity = _velocity
		parent_node.move_and_slide()
		_velocity = parent_node.velocity
	else:
		print("Use physcisbody2D as parent for boidcomponent")
		velocity = _velocity
		move_and_slide()
		_velocity = velocity
		parent_node.position += _velocity * _delta  # Apply the calculated movement to the parent
	

	

func get_flock_status(flock: Array):
	var center_vector := Vector2()
	var flock_center := Vector2()
	var align_vector := Vector2()
	var avoid_vector := Vector2()
	
	for body in flock:
		var f = null
		for child in body.get_children():
			if child is BoidComponent:
				f = child
				break
		if f == null:
			break
		var neighbor_pos: Vector2 = f.global_position
		
		align_vector += f._velocity
		flock_center += neighbor_pos
		
		var d = global_position.distance_to(neighbor_pos)
		if d > 0 and d < avoid_distance:
			avoid_vector -= (neighbor_pos - global_position).normalized() * (avoid_distance / d * max_speed)
		
	var flock_size = flock.size()
	if flock_size:
		align_vector /= flock_size
		flock_center /= flock_size
		var center_dir = global_position.direction_to(flock_center)
		var center_speed = max_speed * (
			global_position.distance_to(flock_center) / flock_area_shape.shape.radius
		)
		center_vector = center_dir * center_speed
	
	return [center_vector, align_vector, avoid_vector]
	
func _part_of_flock(body):
	return body is Bee and body.bee_type == parent_node.bee_type and body != parent_node
	
func _on_flockview_body_entered(body):
	if _part_of_flock(body):
		_flock.append(body)
		
func _on_flockview_body_exited(body):
	if _part_of_flock(body):
		_flock.remove_at(_flock.find(body))
