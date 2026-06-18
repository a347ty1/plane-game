extends Node2D
signal scored



@export var score = 0

var default_font : Font = ThemeDB.fallback_font;
@export var target = preload("res://target.tscn")
var timer
var target_count 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer = get_node("Timer")
	update_target_count()
	timer.timeout.connect(_on_timer_timeout)
	placeTarget()

func _on_timer_timeout():
	placeTarget()
	update_target_count()
	queue_redraw()

func _draw():
	update_target_count()
	draw_string(
		default_font,
		Vector2(100,100),
		"%s Points" % score,
		HORIZONTAL_ALIGNMENT_CENTER,
		-1,
		64
	)
	draw_string(
		default_font,
		Vector2(500,100),
		"%s Targets Remaining" % target_count,
		HORIZONTAL_ALIGNMENT_CENTER,
		-1,
		64
	)
	

func placeTarget():
	if target_count >= 10:
		return
	var rect : Rect2 = get_viewport_rect()
	var x = randi_range(rect.size.x * 0.1, rect.size.x*0.9)
	var y = randi_range(rect.size.y * 0.1 , rect.size.y * 0.9)
	
	$targetPlacer.position = Vector2(x,y)
	
	var b = target.instantiate()
	add_child(b)
	b.owner = self
	b.transform = $targetPlacer.transform
	b.add_to_group("target")

func _on_scored():
	score += 1
	queue_redraw()
	update_target_count()
	return score

func update_target_count():
	target_count =  get_tree().get_node_count_in_group("target")
	
	
	
