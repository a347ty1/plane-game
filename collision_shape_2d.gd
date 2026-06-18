extends CollisionShape2D


@export var Bullet = preload("res://bullet.tscn")
var leftGunNext = true
var gunReady = true

var timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = get_node("gunTimer")
	timer.timeout.connect(_on_timer_timeout)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if Input.is_action_pressed("guns") && gunReady:
		if leftGunNext:
			shoot($leftGun)
		else: 
			shoot($rightGun)
		leftGunNext = !leftGunNext
		gunReady=false
		timer.start()

func _on_timer_timeout():
	gunReady = true
	timer.stop()
	

func shoot(gun):
	var b = Bullet.instantiate()
	owner.add_child(b)
	b.owner = owner
	b.add_to_group("bullet")
	b.transform = gun.global_transform
	
	
func _on_scored():
	owner._on_scored()
