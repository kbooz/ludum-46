extends Node

onready var partyometer = $CanvasLayer/Control/TextureProgress
onready var levelLabel = $CanvasLayer/Control/Level
onready var partyometerTimer = $PartyometerTimer

var player
var props
var issues = 0
var level = 0
var movements = 0

func _ready():
	VisualServer.set_default_clear_color(Color("#232323"))
	player = get_tree().get_nodes_in_group("player")[0]
	props = get_tree().get_nodes_in_group("props")

func init():
	level = 0
	movements = 0

func _process(delta):
	var props_total_issues = check_props_issues()
	issues = props_total_issues
	
	var disaster_chance = clamp(level-2, 0, 9) / 10.0
	
	if partyometer.value <= 0:
		get_tree().change_scene("res://Test Scenes/Scenes/GameOver.tscn")

func check_props_issues():
	var total_issues = 0
	if props:
		for k in props:
			total_issues += int(k.has_issues)
	return total_issues

func request_refill(prop):
	if prop.resource == GlobalResources.RESOURCES.MUSIC:
		if player.resource == GlobalResources.RESOURCES.EMPTY:
			if prop.curr_resource < prop.issues_threshold:
				prop.curr_resource = prop.resource_max
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
			prop.curr_resource = prop.resource_max
			movements += 1
			if (movements % 3 == 0):
				level += 1
				levelLabel.text = "Level " + str(level)
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
		
	player.resource = handout.resource
	$CanvasLayer/Control/AnimationPlayer.play(animations[handout.resource])

func _on_PartyometerTimer_timeout():
	if issues > 0:
		partyometer.value -= 1
	else:
		partyometer.value += 1
