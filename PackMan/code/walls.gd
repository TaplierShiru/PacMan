extends TileMap

onready var half_cell_size = get_cell_size()/2
onready var death = preload("res://Game over/Game_Over.tscn")
onready var player = get_parent().get_parent().get_node("pacman")
onready var red = get_parent().get_parent().get_node("red_ghost")
onready var label = get_parent().get_parent().get_node("score")
onready var pink = get_parent().get_parent().get_node("pinkgay")
onready var time = get_parent().get_parent().get_node("TimerForPink")
onready var blue = get_parent().get_parent().get_node("blue_ghost")
onready var orange = get_parent().get_parent().get_node("orange_ghost")
onready var timeBust = get_parent().get_parent().get_node("TimeBust")
onready var timePause = get_parent().get_parent().get_node("Pause_Points")
var move_blue = false
var move_orange = false
var count = 242;
var pointPlus = 0;
var pointScore = 200;
var pacmanEat 

func _ready():
	time.start()
	player.position = get_player_init_pos()

func get_player_init_pos():
	var pos = map_to_world(Vector2(13,23))
	return pos

func is_title_vacant(pos,direction):
	var curr_tile = world_to_map(pos)
	var next_tile = get_cellv(curr_tile + direction)
	var next_tile_pos = Vector2()
	if next_tile == 12 or next_tile == 13 or next_tile == 14 :
		next_tile_pos = map_to_world(curr_tile + direction) +half_cell_size
	else :
		next_tile_pos = relocate(pos) 
	return next_tile_pos

func relocate(pos):
	var tile = world_to_map(pos)
	return map_to_world(tile) + half_cell_size

# code then i inter coin ( what eat pacman mean)
func eat(pos): 
	var curr_tile = world_to_map(pos)
	var tile = get_cellv(curr_tile)
	if tile == 13 or tile == 14:
		if tile == 13:
			label.text = str(int(label.text) + 10);
			count-=1;
		else: 
			timeBust.start()
			_start_fear(pink)
			_start_fear(blue)
			_start_fear(red)
			_start_fear(orange)
		set_cellv(curr_tile, 12)

func get_path_to_player(who):
	var path1 = get_parent().get_simple_path(who.position, player.position, false)
	return path1

func _process(delta):
	if count == 0:
		print("win")
		set_process(false)
	else:
		if count <= 200 and !move_blue:
			blue.speed = 35
			move_blue = true
			blue.animate = blue.get_node("anim")
			blue.path = get_path_home_blue()
			blue.time = get_parent().get_parent().get_node("searchForBlue")
			blue.set_process(true)
		if count <=120 and !move_orange:
			orange.speed = 45
			move_orange = true
			orange.animate = orange.get_node("anim")
			orange.time = get_parent().get_parent().get_node("searchForOrange")
			orange.path = get_path_home_orange()
			orange.set_process(true)

func get_path_home_red():
	var path_red = get_parent().get_simple_path(red.position,Vector2(171,44),false)
	path_red.push_back(Vector2(211,44))
	path_red.push_back(Vector2(211,12))
	path_red.push_back(Vector2(171,12))
	return path_red

func get_path_home_pink():
	var path_pink = get_parent().get_simple_path(pink.position,Vector2(51,44),false)
	path_pink.push_back(Vector2(51,12))
	path_pink.push_back(Vector2(12,12))
	path_pink.push_back(Vector2(12,44))
	return path_pink

func get_path_home_blue():
	var path_blue = get_parent().get_simple_path(blue.position,Vector2(172,190),false)
	path_blue.push_back(Vector2(172,212))
	path_blue.push_back(Vector2(212,212))
	path_blue.push_back(Vector2(212,235))
	path_blue.push_back(Vector2(124,235))
	path_blue.push_back(Vector2(124,212))
	path_blue.push_back(Vector2(147,212))
	return path_blue

func get_path_home_orange():
	var path_orange = get_parent().get_simple_path(orange.position,Vector2(52,190),false)
	path_orange.push_back(Vector2(52,212))
	path_orange.push_back(Vector2(12,212))
	path_orange.push_back(Vector2(12,235))
	path_orange.push_back(Vector2(100,235))
	path_orange.push_back(Vector2(100,212))
	path_orange.push_back(Vector2(76,212))
	return path_orange

func _start_fear(who):
	if !who.eyes:
		who.fear = true
		who.time.stop()
		who.get_node("anim").stop(true)
		who.get_node("fear").show()
		who.get_node("anim").play("fear")
		who.oldspeed = who.speed
		who.speed = 20


func refresh_home():
	red.path = get_path_home_red()
	orange.path = get_path_home_orange()
	blue.path = get_path_home_blue()
	pink.path = get_path_home_pink()

func _on_TimeBust_timeout():
	_off_bust(pink)
	_off_bust(orange)
	_off_bust(red)
	_off_bust(blue)
	pointScore = 200
	pointPlus = 0

func _off_bust(who):
	if !who.eyes :
		who.fear = false
		who.get_node("fear").hide()
		who.get_node("anim").stop(true)
		who.time.start()
		who.wasIt = false


func count_points(who):
	if pointPlus > 4:
		pointScore = 200
		pointPlus = 0
	who.get_node("CollisionShape2D").disabled = true
	pacmanEat = who
	pacmanEat.get_node("ghost").hide()
	pacmanEat.get_node("fear").hide()
	pacmanEat.get_node("point").show()
	pacmanEat.get_node("point").set_frame(pointPlus)
	label.text = str(int(label.text) + pointScore)
	timePause.start()
	pointPlus+=1
	pointScore*=2

func _on_TimerForPink_timeout():
	pink.time = get_parent().get_parent().get_node("searchForPink")
	pink.path = get_path_home_pink()
	pink.animate = pink.get_node("anim")
	pink.set_process(true)

func _on_Pause_Points_timeout():
	pacmanEat.get_node("point").hide()
	pacmanEat.run_away(pacmanEat)

func _on_leftBoard_area_entered(area):
	area.position = Vector2(207,116)

func _on_rightBoard_area_entered(area):
	area.position = Vector2(16,116)


func Game_over():
	get_parent().get_parent().add_child(death.instance())