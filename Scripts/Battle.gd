extends Node

const PRESS = preload("res://Precission.tscn")

onready var player = get_node("Player")
onready var sebas = get_node("Sebas")
onready var enemy = get_node("Enemy")
onready var prompt = get_node("Dialog")
onready var attackBtn = $Dialog/PanelContainer/Container/HBoxContainer/Attack
onready var specialBtn = $Dialog/PanelContainer/Container/HBoxContainer/Special
var currState
var heroes = []
var enemies = []

enum battleStates{
	PLAYERSELECT,
	PLAYERACT,
	ENEMYSELECT,
	ENEMYACT
}

func _ready():
	player.prompt = prompt
	player.get_node("AnimationPlayer").play("PlayerIdle")
	heroes.append(player)
	
	sebas.prompt = prompt
	sebas.get_node("AnimationPlayer").play("PlayerIdle")
	heroes.append(sebas)
	
	enemy.prompt = prompt
	enemies.append(enemy)
	currState = battleStates.PLAYERSELECT
	get_node("Dialog/PanelContainer/Container/HBoxContainer/Special").connect("pressed", heroes[0], "specialplay", [enemy])
	get_node("Dialog/PanelContainer/Container/HBoxContainer/Attack").connect("pressed", heroes[0], "attacking", [get_node("Enemy"), player.attck])

func nextState():
	if currState == battleStates.PLAYERSELECT:
		currState = battleStates.PLAYERACT
	elif currState == battleStates.PLAYERACT:
		currState = battleStates.ENEMYSELECT
	elif currState == battleStates.ENEMYSELECT:
		currState = battleStates.ENEMYACT
	elif currState == battleStates.ENEMYACT:
		currState = battleStates.PLAYERSELECT
		if !heroesAlive():
			nextState()
			nextState()
	prompt.switch(currState)
	#print("state: " + str(currState))
	
	if currState == battleStates.ENEMYSELECT:
		
		if heroesAlive():
			enemySelect()
		else:
			prompt.messages.append("you lost")
			attackBtn.disabled = true
			specialBtn.disabled = true
			enemyAct()
			return
	elif currState == battleStates.ENEMYACT:
		enemyAct()

func heroesAlive():
	for h in heroes:
		if h.hp > 0:
			return true
	return false

func enemySelect():
	#print("Enemigo seleccionando")
	randomize()
	var rand = randi()%5
	var target = 0
	while true:
		target = randi()%heroes.size()
		if heroes[target].hp > 0:
			break
		
	print(target)
	if rand > 0:
		enemy.attack(heroes[target], enemy.attck)
	else:
		enemy.special(heroes[target])

func enemyAct():
	enemy.get_node("AnimationPlayer").play("EnemyAttack")
	#print("enemigo atacando")