extends Control

func _on_DiogohexTwitter_pressed():
	OS.shell_open("https://twitter.com/diogohex")

func _on_DiogohexGithub_pressed():
	OS.shell_open("https://github.com/Diogoamorim27")

func _on_InachoGithub_pressed():
	OS.shell_open("https://github.com/schweller")

func _on_InachoTwitter_pressed():
	OS.shell_open("https://twitter.com/inacho_")

func _on_ZeTwitter_pressed():
	OS.shell_open("https://twitter.com/ZezaumZZZ")

func _on_ZeBehance_pressed():
	OS.shell_open("https://www.behance.net/fosejelipe")

func _on_KboozTwitter_pressed():
	OS.shell_open("https://twitter.com/kbooz")

func _on_KboozBehance_pressed():
	OS.shell_open("http://kbooz.com/")

func _on_Button_pressed():
	get_tree().change_scene(GlobalResources.previous_scene)
