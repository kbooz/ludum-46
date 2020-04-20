extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _process(delta):
	if Input.is_action_just_pressed("ui_click_left"):
		print("click")
		get_tree().change_scene("res://Test Scenes/LevelDesignTest.tscn")
