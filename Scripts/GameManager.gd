extends Node2D

var player

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

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
	
