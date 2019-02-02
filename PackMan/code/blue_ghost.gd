extends "res://code/enemy.gd"

func _on_blue_ghost_area_entered(area):
	if(area.name == "pacman" and !fear):
		var player = get_parent().get_node("pacman")
		player._death()
		set_process(false)
		print("Game Over")
	elif area.name == "pacman" and !eyes:
		self.relax = true 
		get_tree().paused = true
		walls.count_points(self)

func _on_searchForBlue_timeout():
	path = walls.get_path_to_player(self)
