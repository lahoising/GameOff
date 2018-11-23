extends "Unit.gd"

onready var hpLabel = get_node("Label")

func _process(delta):
	hpLabel.text = "HP: "+str(hp)

func endAttack():
	get_node("AnimationPlayer").play("EnemyBody")
	prompt.moving = false