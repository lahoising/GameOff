extends Node2D

export(int) var hp
export(int) var attck
export(int) var defense
export(int) var sp
onready var prompt
onready var hpLabel = get_node("Label")

func attack(target, power):
	#if hp > 0:
	target.takeDamage(power, target.name)
	prompt.moving = true
	nextState()

func special(target):
	#if hp > 0:
	prompt.messages.append("we're number one")
	prompt.moving = true
	nextState()

func nextState():
	get_parent().nextState()

func takeDamage(power, n):
	var damage = power - defense
	if damage > 0:
		hp -= damage
		prompt.messages.append(n+" took "+str(damage)+" damage")
	elif power > 0:
		hp -= 1
		prompt.messages.append(n+" took 1 damage")
	else:
		prompt.messages.append("You're too weak to attack")
	
	if (hp < 0):
			hp = 0
