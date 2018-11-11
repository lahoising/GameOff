extends Node2D

var pointer
var target
var power

func _ready():
	pointer = 0
	get_tree().paused = true

func _input(event):
	if event.is_action_pressed("ui_select"):
		get_node("AnimationPlayer").stop()
		$AnimationPlayer.play("PointerStart")
		get_parent().get_parent().get_node("Player").attack(target, power*getPoint())
		get_tree().paused = false
		queue_free()

func setRed():
	pointer = 0

func setYellow():
	pointer = 1

func setGreen():
	pointer = 2

func getPoint():
	#red
	if pointer == 0:
		return 0
	#yellow
	elif pointer == 1:
		return 0.7
	#green
	else:
		return 1