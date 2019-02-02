extends Area2D

onready var walls = get_parent().get_node("Navigation2D/walls")
onready var time = get_parent().get_node("searchForPink")
onready var animate
onready var dir

var path = []
var direction = Vector2(0,0)
var speed = 30
var fear = false
var wasIt = false
var eyes = false
var oldspeed = 0
var relax = true

func _ready():
	set_process(false)

func _process(delta):
	if !relax :
		if fear and !wasIt:
			walls.refresh_home()
			wasIt = true
		if eyes :
			if path.size() >= 1 :
				var pos_to_move = path[0]
				direction = (pos_to_move - position).normalized()
				var distance = position.distance_to(path[0])
				if distance > 1 :
					if direction.y > 0.8:
						dir.set_frame(3)
					elif direction.y < -0.8:
						dir.set_frame(2)
					elif direction.x > 0.8:
						dir.set_frame(0)
					elif direction.x < -0.8:
						dir.set_frame(1)
					position += speed * delta * direction
				else :
					path.remove(0)
			else :
				self.get_node("CollisionShape2D").disabled = false
				speed = oldspeed
				dir.hide()
				self.get_node("ghost").show()
				relax = true
				eyes = false
				time.start()
	elif path.size() >= 1 :
		var pos_to_move = path[0]
		direction = (pos_to_move - position).normalized()
		var distance = position.distance_to(path[0])
		if distance > 1 :
			if fear == false and !animate.is_playing():
				if direction.y > 0.8:
					animate.play("down")
				elif direction.y < -0.8:
					animate.play("up")
				elif direction.x > 0.8:
					animate.play("right")
				elif direction.x < -0.8:
					animate.play("left")
			position += speed * delta * direction
		else :
			path.remove(0)
	elif !fear :
		time.start()
		path = walls.get_path_to_player(self)
	else:
		walls.refresh_home()

func run_away(pacmanEat):
	pacmanEat.speed = 120
	pacmanEat.fear = false
	pacmanEat.animate.stop(true)
	pacmanEat.eyes = true
	pacmanEat.path = walls.get_parent().get_simple_path(pacmanEat.position,Vector2(132,108),false)
	get_tree().paused = false
	pacmanEat.dir = pacmanEat.get_node("eyes/look")
	pacmanEat.dir.show()
	pacmanEat.relax = false