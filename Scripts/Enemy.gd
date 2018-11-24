extends "Unit.gd"

var inside = false

func endAttack():
	get_node("AnimationPlayer").play("EnemyBody")
	prompt.moving = false

func _input(event):
	if event.is_action_pressed("lclick") and inside:
		get_parent().btnDisconnect()
		get_parent().target = self
		get_parent().btnConnect()
		get_parent().selector.rect_global_position = global_position - Vector2(8,8)
		prompt.eLabel.text = "Target: "+name

func enemySelect(heroes):
	randomize()
	var rand = randi()%5
	var target = 0
	while true:
		target = randi()%heroes.size()
		if heroes[target].hp > 0:
			break
		
	if rand > 0:
		attack(heroes[target], attck)
	else:
		special(heroes[target])

func enemyAct():
	get_node("AnimationPlayer").play("EnemyAttack")

func _on_Area2D_mouse_entered():
	if hp > 0:
		inside = true

func _on_Area2D_mouse_exited():
	inside = false
