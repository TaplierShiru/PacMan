extends Area2D

var speed = 6
var direction = Vector2(0,0)
onready var walls = get_parent().get_node("Navigation2D/walls")

func _ready():
	$death.hide()
	$AnimatedSprite.play("pac")

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		direction = Vector2(0, -1)
		rotation = -PI/2
	if Input.is_action_pressed("ui_down"):
		direction = Vector2(0, 1)
		rotation = PI/2
	if Input.is_action_pressed("ui_right"):
		direction = Vector2(1, 0)
		rotation = 0
	if Input.is_action_pressed("ui_left"):
		direction = Vector2(-1, 0)
		rotation = PI
	if direction != Vector2(0, 0) :
		position = position.linear_interpolate(walls.is_title_vacant(position,direction),speed*delta)
		walls.eat(position)

func _death():
	$death.show()
	$anime.play("death")
	set_process(false)
	walls.Game_over()

func _on_anim_animation_finished(anim_name):
	$death.hide()
	$AnimatedSprite.hide()
