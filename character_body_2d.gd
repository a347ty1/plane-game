extends CharacterBody2D


@onready var _collision_shape = $CollisionShape2D
@onready var _animation_player = $CollisionShape2D/AnimatedSprite2D

var default_font : Font = ThemeDB.fallback_font;

const MAX_VELOCITY = 300.0
const MAX_TORQUE = 1
const MAX_ROTATION_SPEED = PI # Maximum radians changed per second
const ROTATIONAL_FRICTION = PI/10
const FRICTION = 100
const DRAG = -1.5
const FORCE = 0

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
var lastDirection = 0

func _on_ready():
	_animation_player.play("rollFull")
	_animation_player.speed_scale = 1
	

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
	elif delta_angle > 0:
		rotationSpeed = rotationSpeed + (MAX_TORQUE)
	elif delta_angle < 0:
		rotationSpeed = rotationSpeed - (MAX_TORQUE)
		
	var frameAngle = clamp(delta_angle, -PI/2, PI/2) + PI/2 # Between 0 and PI
	var frame = floor(33 * frameAngle/PI)
	_animation_player.set_frame(frame)
		
	#if lastDirection != rotationSpeed:
		#if (rotationSpeed > 0.01):
			#_animation_player.play_backwards("rollRight")
		#elif(rotationSpeed < -0.01):
			#_animation_player.play("rollLeft")
		#else:
			#_animation_player.play("idle")
		#lastDirection = rotationSpeed

	rotationSpeed = clamp(rotationSpeed, -MAX_ROTATION_SPEED, MAX_ROTATION_SPEED)
	_collision_shape.rotate(rotationSpeed * delta)
	_collision_shape.rotation = fmod(_collision_shape.rotation, 2*PI)
	
	velocity = facing * MAX_VELOCITY
	
	
	move_and_slide()
	queue_redraw()
	
	
	

#func _draw():
	#draw_line(_collision_shape.position, difference_N, Color(1,1,1), 8)
	#draw_line(_collision_shape.position, facing*1000, Color(1,0,0), 8)
	#draw_string(default_font, _collision_shape.position + Vector2(200,200), "%s" % rotationSpeed, HORIZONTAL_ALIGNMENT_CENTER, -1, 128 )
	

	
func _on_scored():
	owner._on_scored()
