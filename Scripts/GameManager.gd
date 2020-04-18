extends Node2D

onready var partyometer = $CanvasLayer/Control/ProgressBar
onready var partyometerTimer = $PartyometerTimer

var player
var props
var merdas_acontecendo = 0

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	props = get_tree().get_nodes_in_group("props")
	collect_resources()

func _process(delta):
	collect_resources()

func collect_resources():
	if props:
		for k in props:
			print(k.curr_resource)

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
	if merdas_acontecendo > 0:
		partyometer.value -= 1
