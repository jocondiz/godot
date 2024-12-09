extends CharacterBody3D

## CAMERA
@onready var camera = $CameraController/SpringArm3D/Camera3D

## WALKING AND RUNNING
@export_group("MOVEMENT")
@export var run_speed := 8.0
@export var walk_speed := 5.0

## JUMP
@export_group("JUMP")
@export var jump_height : float = 2.55
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.3

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

func _physics_process(delta: float) -> void:
	
	walk()
	
	jump(delta)
	
	move_and_slide()
	
func walk() -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down").rotated(-camera.global_rotation.y)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var running: bool = Input.is_action_pressed("run")
	var speed = run_speed if running else walk_speed
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

func jump(delta) -> void:
	if is_on_floor(): 
		if Input.is_action_just_pressed("jump"):
			velocity.y += -jump_velocity
	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	velocity.y -= gravity * delta

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
