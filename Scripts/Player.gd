extends "Unit.gd"

onready var hpLabel = get_node("Label")
const PRES = preload("res://Precission.tscn")

func _process(delta):
	hpLabel.text = "HP: "+str(hp)

func attacking(target, power):
	get_node("AnimationPlayer").play("PlayerAttack")
	var pres = PRES.instance()
	add_child(pres)
	pres.global_position = Vector2(0,0)
	pres.target = target
	pres.power = power
	pres.get_node("AnimationPlayer").play("PointerMove")

func special(target):
	get_node("AnimationPlayer").play("PlayerAttack")
	.special(target)

func endAnimation():
	get_node("AnimationPlayer").play("PlayerIdle")
	prompt.moving = false