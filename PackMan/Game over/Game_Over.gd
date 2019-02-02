extends Control

func _ready():
	get_tree().paused = true
	$anim.play("game_over")

func _on_replay_pressed():
	Global.goto_scene("res://game/game.tscn")


func _on_exit_pressed():
	get_tree().quit()
