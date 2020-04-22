extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	GlobalResources.previous_scene = self.filename

func _on_StartButton_pressed():
	get_tree().change_scene("res://Test Scenes/LevelDesignTest.tscn")

func _on_HowToPlayButton_pressed():
	get_tree().change_scene("res://Test Scenes/Scenes/Tutorial.tscn")

func _on_CreditsButton_pressed():
	get_tree().change_scene("res://Test Scenes/Scenes/Credits.tscn")


func _on_LeaderboardButton_pressed():
	pass # Replace with function body.
