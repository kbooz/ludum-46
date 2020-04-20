extends KinematicBody2D

export (int) var MAX_SPEED = 200
export (int) var ACCELERATION = 500
export (int) var FRICTION = 800

var emptySprite = preload("res://assets-originals/png/spritesheet-128.png")
var beerSprite = preload("res://assets-originals/png/char-beer-spritesheet.png")
var foodSprite = preload("res://assets-originals/png/char-food-spritesheet.png")

onready var Animator = $AnimationPlayer
onready var sprite = $Sprite

var velocity = Vector2.ZERO
var resource = GlobalResources.RESOURCES.EMPTY
var facing_left = false

var sprites = {
	GlobalResources.RESOURCES.EMPTY: emptySprite,
	GlobalResources.RESOURCES.BEER: beerSprite,
	GlobalResources.RESOURCES.FOOD: foodSprite
}

func _physics_process(delta):
	sprite.texture = sprites[resource]
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if input_vector.x < 0:
			facing_left = true
		elif input_vector.x > 0:
			facing_left = false
		Animator.play("Walk")
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		Animator.stop()
		sprite.frame = 0
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if facing_left:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1
	
	move()

func move():
	velocity = move_and_slide(velocity)
