extends Node2D

onready var colors = get_node("Rainbow")
onready var one = preload("res://test/1.png")
onready var two = preload("res://test/2.png")
onready var three = preload("res://test/3.png")
onready var fo = preload("res://test/4.png")
onready var five = preload("res://test/5.png")
onready var six = preload("res://test/6.png")
onready var seven = preload("res://test/7.png")

onready var rainboww = [one,two,three,fo,five,six,seven]



func _ready():
	$"1".texture = rainboww[0]
	
	$"2".texture = rainboww[1]
	$"3".texture = rainboww[2]
	$"4".texture = rainboww[3]
	$"5".texture = rainboww[4]
	$"6".texture = rainboww[5]
	$"7".texture = rainboww[6]

#func _process(delta):
	#var frame  = randi() % 7
	#colors.texture = rainboww[frame-1]
	#$Flow.texture = rainboww[frame-1]
