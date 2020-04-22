extends Control

const API_URL = "http://dreamlo.com/lb/"

var api_key
var api_url

func _ready():
	var file = File.new()
	file.open("res://leaderboard_api.txt", File.READ)
	api_key = file.get_as_text()
	api_url = API_URL + api_key

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		_add_score("kai","10", "6-54", "60")

func _add_score(name, level, time, people):
	var request = api_url + "/add-json/" + name + "/" + time + "/" + level + "/" + people
	print(request)
	$HTTPRequest.request(request)
	
func _read_leaderboard():
	var request = api_url + "/json"
	$HTTPRequest.request(request)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var results = body.get_string_from_utf8()
	print(results)
	pass # Replace with function body.
