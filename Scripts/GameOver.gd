extends Control

func _ready():
	GlobalResources.previous_scene = self.filename
	var string = "Nice Job!\n\n You kept the party going for %d:%d!\n\n%d people attended!\n\nYou got to level %d!"
	$Panel/Label.text =  string % [GlobalResources.time_mins, GlobalResources.time_secs, GlobalResources.max_attendance, GlobalResources.level_reached]

func _on_Button_pressed():
	get_tree().change_scene("res://Test Scenes/LevelDesignTest.tscn")
	pass # Replace with function body.

func _on_Button3_pressed():
	get_tree().change_scene("res://Test Scenes/Scenes/StartScreen.tscn")
	pass # Replace with function body.

func _on_Button2_pressed():
	get_tree().change_scene("res://Test Scenes/Scenes/Credits.tscn")
