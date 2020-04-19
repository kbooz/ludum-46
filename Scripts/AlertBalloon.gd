extends Node2D

# Check if target is off screen
# Set origin coordinate at the center of the screen
# Check if sprite should be rendered on top or bottom half (player position)
# Algebraic substitution 

onready var sprite = $Sprite
onready var icon = $Sprite/Icon

var target_position = null
var active = false
var has_played = false

func _ready():
	hide()

func set_balloon_position(bounds : Rect2):
	if target_position == null:
		sprite.global_position.x = clamp(global_position.x, bounds.position.x, bounds.end.x)
		sprite.global_position.y = clamp(global_position.y, bounds.position.y, bounds.end.y)
	else: 
		var displacement = global_position - target_position
		var length
		
		var topLeft = (bounds.position - target_position).angle()
		var topRight = (Vector2(bounds.end.x, bounds.position.y) - target_position).angle()
		var bottomLeft = (Vector2(bounds.position.x, bounds.end.y) - target_position).angle()
		var bottomRight = (bounds.end - target_position).angle()
		if (displacement.angle() > topLeft && displacement.angle() < topRight) \
			|| (displacement.angle() < bottomLeft && displacement.angle() > bottomRight):
			var y_length = clamp(displacement.y, bounds.position.y - target_position.y,
				bounds.end.y - target_position.y)
			var angle = displacement.angle() - PI / 2.0
			length = y_length / cos(angle) if cos(angle) !=0 else y_length
		else:
			var x_length = clamp(displacement.x, bounds.position.x - target_position.x,
				bounds.end.x - target_position.x)
			var angle = displacement.angle()
			length = x_length / cos(angle) if cos(angle) !=0 else x_length
		
		sprite.global_position = polar2cartesian(length, displacement.angle()) + target_position
	
	if bounds.has_point(global_position):
		hide()
	else:
		show()
		if !has_played:
			$AudioStreamPlayer2D.play(1)
			has_played = true

func set_balloon_rotation():
	# get the displacement vector
	var angle = (global_position - sprite.global_position).angle()
	sprite.global_rotation = angle
	icon.global_rotation = 0

func _physics_process(delta):
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()
	
	if active:
		set_balloon_position(Rect2(top_left, size))
		set_balloon_rotation()
