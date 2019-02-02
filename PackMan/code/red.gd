extends "res://code/enemy.gd"

func _ready():
	speed = 27
	animate = get_node("anim")
	time = get_parent().get_node("searchForRed")
	position = Vector2(111,92)
	path = walls.get_path_home_red()
	set_process(true)

func _on_red_ghost_area_entered(area):
	if(area.name == "pacman" and !fear):
		var player = get_parent().get_node("pacman")
		player._death()
		set_process(false)
		print("Game Over")
	elif area.name == "pacman":
		self.relax = true 
		get_tree().paused = true
		walls.count_points(self)

func _on_search_timeout():
	path = walls.get_path_to_player(self)
