extends Node

const MAX_WEIGHT: float = 245.0
const MAX_LIFT_WEIGHT: float = 70.0
const MAX_SPEED: float = 10.0
const WEIGHT_EXPONENT: float = 1.5
const THROW_SPEED: float = 10.0

var grabbed_object: GrabbableObject

@onready var grab_arm: SpringArm3D = %GrabArm
@onready var grab_anchor: Marker3D = %GrabAnchor


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug"): throw_object()
	if Input.is_action_just_pressed("grab"): 
		if %InteractionRayCast.get_collider() is GrabbableObject: grab_object(%InteractionRayCast.get_collider())


func _physics_process(delta: float) -> void:
	if not grabbed_object: return
	
	var direction: Vector3 = grab_anchor.global_position - grabbed_object.global_position
	var speed_weight_xz: float = clampf(remap(grabbed_object.mass, 1.0, MAX_WEIGHT, 0.0, 1.0), 0.0, 1.0)
	var speed_weight_y: float = clampf(remap(grabbed_object.mass, 1.0, MAX_LIFT_WEIGHT, 0.0, 1.0), 0.0, 1.0)
	var remapped_speed_xz: float = lerpf(MAX_SPEED, 0.0, speed_weight_xz ** WEIGHT_EXPONENT)
	var remapped_speed_y: float = lerpf(MAX_SPEED, 0.0, speed_weight_y ** WEIGHT_EXPONENT)
	
	grabbed_object.linear_velocity.x = (direction * minf(remapped_speed_xz, MAX_SPEED)).x
	grabbed_object.linear_velocity.y = (direction * minf(remapped_speed_y, MAX_SPEED)).y
	grabbed_object.linear_velocity.z = (direction * minf(remapped_speed_xz, MAX_SPEED)).z
	grabbed_object.angular_velocity *= 0.75


func grab_object(object: GrabbableObject) -> void:
	if object == grabbed_object: return
	
	grabbed_object = object
	grabbed_object.is_grabbed = true
	grab_arm.add_excluded_object(grabbed_object.get_rid())


func drop_object() -> void:
	if not grabbed_object: return
	
	grab_arm.clear_excluded_objects()
	grabbed_object.is_grabbed = false
	grabbed_object = null


func throw_object() -> void:
	if not grabbed_object: return
	
	grabbed_object.apply_central_impulse(grab_anchor.global_basis.z * THROW_SPEED)
	grabbed_object.apply_torque_impulse(Vector3(randf(), randf(), randf()))
	drop_object()
