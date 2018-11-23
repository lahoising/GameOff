extends "Player.gd"

const GAME = preload("res://Laberinto.tscn")

func specialplay(target):
	get_node("AnimationPlayer").play("PlayerAttack")
	var game = GAME.instance()
	get_parent().get_node("Games").add_child(game)
	game.rect_global_position = Vector2(0,0)
	game.target = target