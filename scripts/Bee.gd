extends CharacterBody2D

class_name Bee

@export var flock_view : Area2D

@export var max_speed: = 500.0
@export var mouse_follow_force: = 0.05
@export var cohesion_force: = 0.05
@export var align_force: = 0.05
@export var separation_force: = 0.06
@export var view_distance := 50.0
@export var avoid_distance := 20.0

@onready var flockview_collision = $FlockView/CollisionShape2D

var _width = ProjectSettings.get_setting("display/window/size/viewport_width")
var _height = ProjectSettings.get_setting("display/window/size/viewport_height")

var _flock: Array = []
var _lure: Beelure = null
var _mouse_target: Vector2
var _velocity: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	_velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * max_speed
	_mouse_target = get_global_mouse_position()
	
func _physics_process(delta):
	if _lure == null:
		_mouse_target = get_global_mouse_position()
	var mouse_vector = Vector2.ZERO
	if _mouse_target != Vector2.INF:
		mouse_vector = global_position.direction_to(_mouse_target) * max_speed * mouse_follow_force
		
	# Get cohesion, alignment, and separation vectors
	var vectors = get_flock_status(_flock)
	
	# Steer towards vectors
	var cohesion_vector = vectors[0] * cohesion_force
	var align_vector = vectors[1] * align_force
	var separation_vector = vectors[2] * separation_force
	
	var acceleration = cohesion_vector + align_vector + separation_vector + mouse_vector
	
	_velocity = (_velocity + acceleration).limit_length(max_speed)
	
	
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
			global_position.distance_to(flock_center) / flockview_collision.shape.radius
		)
		center_vector = center_dir * center_speed
	
	return [center_vector, align_vector, avoid_vector]
		


func _on_flockview_body_entered(body):
	print("Body entered")
	if body is Beelure:
		print("Beelure entered")
		if _lure == null:
			_lure = body
			_mouse_target = body.global_position
	elif self != body:
		print("Bee entered")
		_flock.append(body)


func _on_flockview_body_exited(body):
	if body is Bee and self != body:
		_flock.remove_at(_flock.find(body))
