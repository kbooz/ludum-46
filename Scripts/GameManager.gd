extends Node

onready var partyometer = $CanvasLayer/Control/TextureProgress
onready var levelLabel = $CanvasLayer/Control/Level
onready var messageLabel = $CanvasLayer/Message
onready var hudAnimator = $CanvasLayer/AnimateHUD
onready var partyometerTimer = $PartyometerTimer

var player
var props
var issues = 0
var level = 0
var movements = 0
var initial_partyometer_depletion_rate = 1
var partyometer_depletion_rate = initial_partyometer_depletion_rate
var partyometer_increase_rate = 1
var guests_displayed = 0
var start_time : int
var end_time : int
var max_attendance = 0
var disaster_chance

func _ready():
	randomize()
	VisualServer.set_default_clear_color(Color("#232323"))
	init()

func init():
	messageLabel.rect_pivot_offset = messageLabel.rect_size / 2
	player = get_tree().get_nodes_in_group("player")[0]
	props = get_tree().get_nodes_in_group("props")
	start_time = OS.get_unix_time()
	level = 1
	movements = 0
	partyometer_depletion_rate = 1
	disaster_chance = 0

func _process(delta):
	var props_total_issues = check_props_issues()
	issues = props_total_issues
	
	# for debugging purposes
	if Input.is_action_just_pressed("ui_accept"):
		increase_level()
		
	if partyometer.value <= 0:
		end_time = OS.get_unix_time()
		GlobalResources.time_mins = (end_time - start_time) / 60
		GlobalResources.time_secs = (end_time - start_time) % 60
		GlobalResources.max_attendance = max_attendance + 30
		GlobalResources.level_reached = level
		
		get_tree().change_scene("res://Test Scenes/Scenes/GameOver.tscn")

func check_props_issues():
	var total_issues = 0
	if props:
		for k in props:
			total_issues += int(k.has_issues)
	return total_issues

func show_message(message):
	messageLabel.text = str(message)
	hudAnimator.play("show_message")

func request_refill(prop):
	if prop.resource == GlobalResources.RESOURCES.MUSIC:
		if player.resource == GlobalResources.RESOURCES.EMPTY:
			if prop.curr_resource < prop.issues_threshold:
				prop.curr_resource += prop.resource_refill
				print("Music Adjusted")
				$Refill.play(1)
				$CanvasLayer/Control/AnimationPlayer.play("empty")
				return true
			else:
				$Fail.play()
				return false
		else:
			print("Hands full")
			$Fail.play()
			return false
			
	if prop.resource == player.resource:
		if prop.curr_resource < prop.issues_threshold:
			player.resource = GlobalResources.RESOURCES.EMPTY
			prop.curr_resource += prop.resource_refill
			movements += 1
			if (movements % 3 == 0):
				increase_level()
			print(level)
			print("Refilled")
			$Refill.play(1)
			$CanvasLayer/Control/AnimationPlayer.play("empty")
			return true
		else:
			$Fail.play()
			return false
	else:
		print("Doesnt have correct resource")
		$Fail.play()
		return false
	pass
	
func request_delivery(handout):
	var animations = ["empty", "beer", "food","music","cleaning"]
	if player.resource != GlobalResources.RESOURCES.EMPTY:
		print("Player has hands full")
		return
	
	if randf() < disaster_chance:
		var disaster_prop = props[randi() % props.size()]
		disaster_prop.curr_resource = disaster_prop.issues_threshold
	
	show_message("You grabbed %s" % animations[handout.resource])
	player.resource = handout.resource
	$CanvasLayer/Control/AnimationPlayer.play(animations[handout.resource])

func increase_level():
	level += 1
	levelLabel.text = "Level " + str(level)
	partyometer_depletion_rate = clamp(ceil(initial_partyometer_depletion_rate * level * 0.75), 1, 7)
	disaster_chance = clamp(level-2, 0, 9) / 10.0

func _on_PartyometerTimer_timeout():
	if issues > 0:
		partyometer.value -= partyometer_depletion_rate
	else:
		partyometer.value += partyometer_increase_rate
	
	guests_displayed = min((partyometer.value / 100) * 4 * level, 40)
	if guests_displayed > max_attendance:
		max_attendance = floor(guests_displayed)
	
	var guests = get_tree().get_nodes_in_group("generic_guests")
	for i in range(guests.size() - 1):
		if i < guests_displayed:
			if guests[i].modulate == Color(1,1,1,0):
				guests[i].animation_player.play("fade_in")
		else:
			guests[i].modulate = Color(1,1,1,0)
		
