extends Node

const PRESS = preload("res://Precission.tscn")

onready var prompt = get_node("Dialog")
onready var attackBtn = $Dialog/PanelContainer/VBoxContainer/HBoxContainer/Attack
onready var specialBtn = $Dialog/PanelContainer/VBoxContainer/HBoxContainer/Special
onready var selector = $Selector
var currState
var heroes = []
var enemies = []
var curr = 0
var target

enum battleStates{
	PLAYERSELECT,
	PLAYERACT,
	ENEMYSELECT,
	ENEMYACT,
	WON,
	LOST
}

func _ready():
	var player = get_node("Player")
	player.prompt = prompt
	player.get_node("AnimationPlayer").play("PlayerIdle")
	heroes.append(player)
	
	var sebas = get_node("Sebas")
	sebas.prompt = prompt
	sebas.get_node("AnimationPlayer").play("PlayerIdle")
	heroes.append(sebas)
	
	var enemy1 = get_node("Enemy")
	enemy1.prompt = prompt
	enemies.append(enemy1)
	
	var enemy2 = get_node("Enemy2")
	enemy2.prompt = prompt
	enemies.append(enemy2)
	
	currState = battleStates.PLAYERSELECT
	target = enemies[0]
	selector.rect_global_position = target.global_position - Vector2(8,8)
	updateHealth()
	while heroes[curr].hp <= 0 and curr < heroes.size():
		curr += 1
	prompt.pLabel.text = "Attacker: "+heroes[curr].name
	prompt.eLabel.text = "Target: "+target.name
	specialBtn.connect("pressed", heroes[curr], "specialplay", [target])
	attackBtn.connect("pressed", heroes[curr], "attacking", [target, heroes[curr].attck])
	attackBtn.grab_focus()

func nextState():
	if currState == battleStates.PLAYERSELECT:
		while target.hp <= 0 and alive(enemies):
			var t = enemies.find(target)
			if t+1 < enemies.size():
				target = enemies[t+1]
			else:
				target = enemies[0]
		while true:
			if curr+1 < heroes.size():
				playerTurn(1)
			else:
				playerTurn(0)
			if heroes[curr].hp > 0:
				break
		currState = battleStates.PLAYERACT
		prompt.pLabel.text = "Attacker: "+heroes[curr].name
		prompt.eLabel.text = "Target: "+target.name
	elif currState == battleStates.PLAYERACT:
		if alive(enemies):
			if curr+1 < heroes.size():
				curr = 0
				while enemies[curr].hp <= 0:
					curr+=1
				currState = battleStates.ENEMYSELECT
			else:
				currState = battleStates.PLAYERSELECT
		else:
			prompt.messages.append("ENHORABUENA")
			currState = battleStates.WON
		updateHealth()
	elif currState == battleStates.ENEMYSELECT:
		currState = battleStates.ENEMYACT
	elif currState == battleStates.ENEMYACT:
		if alive(heroes):
			if curr+1 < enemies.size():
				currState = battleStates.PLAYERSELECT
				curr = 0
			else:
				currState = battleStates.ENEMYSELECT
		else:
			prompt.messages.append("You Lost")
			currState = battleStates.LOST
		updateHealth()
	prompt.switch(currState)
	selector.rect_global_position = target.global_position - Vector2(8,8)
	#print("state: " + str(currState))
	
	if currState == battleStates.ENEMYSELECT:
		if alive(heroes):
			enemies[curr].enemySelect(heroes)
		else:
			prompt.messages.append("you lost")
			attackBtn.disabled = true
			specialBtn.disabled = true
			currState = battleStates.LOST
	elif currState == battleStates.ENEMYACT:
		enemies[curr].enemyAct()
		if curr+1 < enemies.size():
			curr += 1
		else:
			curr = 0

func playerTurn(c):
	btnDisconnect()
	if bool(c):
		curr += 1
	else:
		curr = 0
	btnConnect()

func btnDisconnect():
	specialBtn.disconnect("pressed", heroes[curr], "specialplay")
	attackBtn.disconnect("pressed", heroes[curr], "attacking")

func btnConnect():
	specialBtn.connect("pressed", heroes[curr], "specialplay", [target])
	attackBtn.connect("pressed", heroes[curr], "attacking", [target, heroes[curr].attck])

func alive(group):
	if group == heroes:
		for h in heroes:
			if h.hp > 0:
				return true
	elif group == enemies:
		for e in enemies:
			if e.hp > 0:
				return true
	return false

func updateHealth():
	for h in heroes:
		h.hpLabel.text ="HP: " + str(h.hp)
	for e in enemies:
		e.hpLabel.text ="HP: " + str(e.hp)