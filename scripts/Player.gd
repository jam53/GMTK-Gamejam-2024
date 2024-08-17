extends CharacterBody2D
## This script is used to control and move the camera around in the play area

@export var speed := 400

func get_input():
    var input_direction := Input.get_vector("left", "right", "up", "down")
    velocity = input_direction * speed

func _physics_process(delta):
    get_input()
    move_and_slide()
