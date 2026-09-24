extends CharacterBody3D
class_name Player

const LOOK_SMOOTHNESS = 50.0
const MAX_CAMERA_LOOK_ANGLE_DEGREES = 90.0

const SPEED = 5.0
const CROUCH_SPEED = 2.5
const SPRINT_SPEED = 7.5
const JUMP_VELOCITY = 4.5
const ACCELERATION = 10.0
const AIR_ACCELERATION = 3.0

#Camera
var can_look: bool = true
var mouse_sensitivity: float = 0.075
var camera_input: Vector2
var camera_rotation_velocity: Vector2

#Movement
var gravity_on: bool = true 
var can_move: bool = true
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var input_dir: Vector2
var crouching: bool = false
var sprinting: bool = false

@onready var standing_collision: CollisionShape3D = %StandingCollision
@onready var crouching_collision: CollisionShape3D = %CrouchingCollision
@onready var camera: Camera3D = %Camera3D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: #Mouse Motion
		if can_look: camera_input = -event.relative
	


func _physics_process(delta: float) -> void:
	_handle_camera(delta)
	_handle_movement(delta)


func enable_input() -> void:
	can_look = true
	can_move = true


func disable_input() -> void:
	can_look = false
	can_move = false


func _handle_camera(delta: float) -> void:
	#Rotation Lerp
	camera_rotation_velocity = camera_rotation_velocity.lerp(camera_input * mouse_sensitivity, LOOK_SMOOTHNESS * delta)
	
	#Apply Rotation
	rotate_y(camera_rotation_velocity.x * mouse_sensitivity)
	camera.rotate_x(camera_rotation_velocity.y * mouse_sensitivity)
	
	#Clamps
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -MAX_CAMERA_LOOK_ANGLE_DEGREES, MAX_CAMERA_LOOK_ANGLE_DEGREES)
	camera.rotation_degrees.y = 0.0
	
	#
	camera_input = Vector2.ZERO


func _handle_movement(delta: float) -> void:
	#Input
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Add Gravity
	if not is_on_floor() and gravity_on:
		velocity.y -= gravity * delta
	
	# Handle Crouching
	if Input.is_action_just_pressed("crouch"): 
		crouching = !crouching
		
		standing_collision.disabled = crouching
		crouching_collision.disabled = !crouching
		
		camera.position.y = 1.5 if not crouching else 0.75
	
	# Handle Sprinting
	sprinting = true if Input.is_action_pressed("sprint") and \
				Input.is_action_pressed("forward") and \
				not crouching and \
				is_on_floor() else false
	
	#Calculate Movement
	var wish_velocity: Vector3 = direction * SPEED if can_move else Vector3.ZERO
	wish_velocity = direction * CROUCH_SPEED if crouching else wish_velocity
	wish_velocity = direction * SPRINT_SPEED if sprinting else wish_velocity
	
	var accel: float = ACCELERATION if is_on_floor() else AIR_ACCELERATION
	
	velocity.x = velocity.lerp(wish_velocity, accel * delta).x
	velocity.z = velocity.lerp(wish_velocity, accel * delta).z
	
	move_and_slide()
