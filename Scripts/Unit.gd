extends Node2D

export(int) var hp
export(int) var attck
export(int) var defense
export(int) var sp
onready var prompt

func _ready():
	pass

func attack(target, power):
	target.takeDamage(power)
	prompt.moving = true
	nextState()

func special(target):
	prompt.messages.append("we're special")
	prompt.moving = true
	nextState()

func nextState():
	get_parent().nextState()

func takeDamage(power):
	var damage = power - defense
	if damage > 0:
		hp -= damage
		if (hp < 0):
			hp = 0
		prompt.messages.append("the target took "+str(damage)+" damage")
		#prompt.switch()
	else:
		hp -= 1
		prompt.messages.append("the target took 1 damage")
