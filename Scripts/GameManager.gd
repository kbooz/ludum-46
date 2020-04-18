extends Node2D

onready var partyometer = $CanvasLayer/Control/ProgressBar
onready var partyometerTimer = $PartyometerTimer

var player
var props
var issues = 0

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	props = get_tree().get_nodes_in_group("props")

func _process(delta):
	var props_total_issues = check_props_issues()
	issues = props_total_issues


func check_props_issues():
	var total_issues = 0
	if props:
		for k in props:
			total_issues += int(k.has_issues)
	return total_issues

func request_refill(prop):
	if prop.resource == player.resource:
		player.resource = GlobalResources.RESOURCES.EMPTY
		prop.curr_resource = prop.resource_max
		print("Refilled")
	else:
		print("Doesnt have correct resource")
	pass
	
func request_delivery(handout):
	if player.resource != GlobalResources.RESOURCES.EMPTY:
		print("Player has hands full")
		return
	
	player.resource = handout.resource

func _on_PartyometerTimer_timeout():
	if issues > 0:
		partyometer.value -= 1
