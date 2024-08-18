# https://github.com/kyrick/godot-boids/tree/master
extends CharacterBody2D

class_name BoidComponent

@onready var flock_area = $FlockArea
@export var sprite : Sprite2D
@export var flock_area_shape : CollisionShape2D

@export var max_speed: = 500.0
@export var target_follow_force: = 0.05
@export var cohesion_force: = 0.05
@export var align_force: = 0.05
@export var separation_force: = 0.05
@export var view_distance := 50.0
@export var avoid_distance := 20.0

@export var lure : Node2D = null
@export var beetype : Enums.BeeType
@export var stopable := false

@export var facing_right := true

var _flock: Array = []
var _velocity: Vector2
var _stop_mouse_follow := false

func _ready():
	randomize()
	_velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * max_speed
	
	if flock_area_shape.get_parent() != null:
		flock_area_shape.get_parent().remove_child(flock_area_shape)

	flock_area.add_child(flock_area_shape)
	
func _process(_delta):
	if stopable and Input.is_action_just_pressed("disable_follow"):
			if _stop_mouse_follow:
				lure = null
			else:
				lure = Node2D.new()
				lure.position = self.global_position
			_stop_mouse_follow = not _stop_mouse_follow

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
			# Target is to the right
			if not facing_right: 
				sprite.flip_h = !sprite.flip_h
				facing_right = true
		elif cross < 0:
			# Target is to the left
			if facing_right:
				sprite.flip_h = !sprite.flip_h
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
	velocity = _velocity
	move_and_slide()
	_velocity = velocity

func get_flock_status(flock: Array):
	var center_vector := Vector2()
	var flock_center := Vector2()
	var align_vector := Vector2()
	var avoid_vector := Vector2()
	
	for f in flock:
		var neighbor_pos: Vector2 = f.global_position
		
		# Update alignmentvector and center based on neighbor		
		align_vector += f._velocity
		flock_center += neighbor_pos
		
		# Calculate avoid vector based on distance to neighbor		
		var d = global_position.distance_to(neighbor_pos)
		if d > 0 and d < avoid_distance:
			avoid_vector -= (neighbor_pos - global_position).normalized() * (avoid_distance / d * max_speed)
		
	var flock_size = flock.size()
	if flock_size:
		# Calculate mean of alignments
		align_vector /= flock_size
		
		# Calculate direction of flock
		flock_center /= flock_size
		var center_dir = global_position.direction_to(flock_center)
		var center_speed = max_speed * (
			global_position.distance_to(flock_center) / flock_area_shape.shape.radius
		)
		center_vector = center_dir * center_speed
	
	return [center_vector, align_vector, avoid_vector]
	
	
func _on_flockview_body_entered(body):
	if body is BoidComponent and body.beetype == self.beetype and body != self:
		_flock.append(body)

func _on_flockview_body_exited(body):
	if body is BoidComponent and body.beetype == self.beetype and body != self:
		_flock.remove_at(_flock.find(body))
