extends Area2D

onready var outline : = $Outline
onready var timer : = $Timer
onready var label : = $Control/Label
onready var tween : = $Tween

export (int) var resource_max = 100
export (int) var curr_resource = 90
export (int) var depletion_rate = 1

export (int, "empty", "beer", "food", "music", "cleaning") var resource
export (bool) var has_issues = false


var game_manager

var is_hovering : = false
var interactive : = false
var initial_label_position = 0
var initial_issues_threshold = 50
var issues_threshold = initial_issues_threshold

func _ready():
	initial_label_position = label.rect_position.y
	outline.visible = false
	label.visible = false
	game_manager = get_tree().get_nodes_in_group("Game Manager")[0]

func _process(_delta):
	issues_threshold = clamp(initial_issues_threshold + ceil(game_manager.level * 1.5), 50, 90)
	
	if curr_resource < issues_threshold:
		$AlertBalloon.active = true
		has_issues = true
	else:
		$AlertBalloon.active = false
		has_issues = false
		
	if is_hovering:
		label.visible = true
		outline.visible = true
		label.text = str(curr_resource) + " / " + str(resource_max)
	else:
		outline.visible = false
		label.visible = false

func _input(event):
	if (event is InputEventMouseButton) and event.is_pressed():
		if is_hovering and interactive:
			game_manager.request_refill(self)

func _on_ResourceProp_area_entered(area):
	if area.name == "CursorTracker":
		is_hovering = true
		

func _on_ResourceProp_area_exited(area):
	if area.name == "CursorTracker":
		is_hovering = false


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		interactive = true
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		interactive = false
	pass # Replace with function body.


func _on_Timer_timeout():
	if curr_resource >= 1:
		curr_resource -= 1
	pass # Replace with function body.

