extends CharacterBody2D


@onready var _collision_shape = $CollisionShape2D


const MAX_VELOCITY = 300.0
const MAX_TORQUE = 1
const MAX_ROTATION_SPEED = PI# Maximum radians changed per second
const ROTATIONAL_FRICTION = PI/10
const FRICTION = 100
const DRAG = -1.5
const FORCE = 100

var mousePos = Vector2()
var difference = Vector2()
var delta_angle = 0
var rotationSpeed = 0.0
var target_angle = 0
var facing = Vector2(1,1)
var speed = 0
var difference_N
var acceleration = Vector2.ZERO
var leftGunNext = true


func _physics_process(delta: float) -> void:
	mousePos = get_local_mouse_position()
	difference = mousePos - _collision_shape.position
	target_angle = difference.angle()
	
	facing = Vector2(cos(_collision_shape.rotation - (PI/2) ), sin(_collision_shape.rotation - (PI/2) )) # Define normal vector on facing
	difference_N = difference
	difference /= difference.length() # Normalise difference vector
	
	delta_angle = facing.angle_to(difference)
	
	if abs(delta_angle)<PI/10:
		rotationSpeed = lerp(rotationSpeed, delta_angle/delta, ROTATIONAL_FRICTION)
	elif delta_angle>0:
		rotationSpeed = rotationSpeed + (MAX_TORQUE)
	elif delta_angle < 0:
		rotationSpeed = rotationSpeed - (MAX_TORQUE)

	rotationSpeed = clamp(rotationSpeed, -MAX_ROTATION_SPEED, MAX_ROTATION_SPEED)
	_collision_shape.rotate(rotationSpeed * delta)
	_collision_shape.rotation = fmod(_collision_shape.rotation, 2*PI)
	
	velocity = facing * 300
	
	
	move_and_slide()
	queue_redraw()
	

#func _draw():
	#draw_line(_collision_shape.position, difference_N, Color(1,1,1), 8)
	#draw_line(_collision_shape.position, facing*1000, Color(1,0,0), 8)
	
func _on_scored():
	owner._on_scored()
