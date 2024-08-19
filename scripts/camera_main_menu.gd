extends CharacterBody2D

@export var camera_speed: float = 75 # Speed at which the camera moves 
@export var camera_direction: Vector2 = Vector2(0.707107, 0.707107) # Direction in which the camera moves

func _physics_process(delta):
	velocity = camera_direction * camera_speed
	move_and_slide()
