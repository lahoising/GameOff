extends "Unit.gd"

onready var hpLabel = get_node("Label")

func _ready():
	pass

func _process(delta):
	hpLabel.text = "HP: "+str(hp)

func attack(target, power):
	get_node("AnimationPlayer").play("PlayerAttack")
	.attack(target, power)

func special(target):
	get_node("AnimationPlayer").play("PlayerAttack")
	.special(target)

func endAnimation():
	get_node("AnimationPlayer").play("PlayerIdle")
	prompt.moving = false