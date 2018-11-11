extends Node

const PRESS = preload("res://Precission.tscn")

onready var player = get_node("Player")
onready var enemy = get_node("Enemy")
onready var prompt = get_node("Dialog")
var currState

enum battleStates{
	PLAYERSELECT,
	PLAYERACT,
	ENEMYSELECT,
	ENEMYACT
}

func _ready():
	player.prompt = prompt
	player.get_node("AnimationPlayer").play("PlayerIdle")
	enemy.prompt = prompt
	currState = battleStates.PLAYERSELECT
	print("state: " + str(currState))
	get_node("Dialog/PanelContainer/Container/HBoxContainer/Special").connect("pressed", player, "special", [enemy])
	get_node("Dialog/PanelContainer/Container/HBoxContainer/Attack").connect("pressed", get_node("Player"), "attacking", [get_node("Enemy"), player.attck])

func nextState():
	if currState == battleStates.PLAYERSELECT:
		currState = battleStates.PLAYERACT
	elif currState == battleStates.PLAYERACT:
		currState = battleStates.ENEMYSELECT
	elif currState == battleStates.ENEMYSELECT:
		currState = battleStates.ENEMYACT
	elif currState == battleStates.ENEMYACT:
		currState = battleStates.PLAYERSELECT
	prompt.switch(currState)
	print("state: " + str(currState))
	
	if currState == battleStates.ENEMYSELECT:
		enemySelect()
	elif currState == battleStates.ENEMYACT:
		enemyAct()

func enemySelect():
	print("Enemigo seleccionando")
	var rand = randi()%2
	if rand == 0:
		enemy.attack(player, enemy.attck)
	else:
		enemy.special(player)

func enemyAct():
	enemy.get_node("AnimationPlayer").play("EnemyAttack")
	print("enemigo atacando")