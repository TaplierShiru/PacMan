extends Control

func _ready():
	$Anim.play("logo")


func _on_Start_pressed():
	print("Load level")
	Global.goto_scene("res://game/game.tscn")


func _on_Exit_pressed():
	get_tree().quit()


