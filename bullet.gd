extends Area2D

var speed = 750
const MAX_DISTANCE = 500
var distance = 0
var velocity

func _physics_process(delta):
	velocity =  Vector2(cos(rotation - (PI/2) ), sin(rotation - (PI/2) )) * speed *  delta # Define normal vector on facing
	position += velocity
	
	distance += speed * delta
	if distance >= MAX_DISTANCE:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("target"):
		owner._on_scored()
		area.queue_free()
		queue_free()
	
