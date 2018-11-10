extends Node

onready var player = get_node("Player")
onready var enemy = get_node("Enemy")
onready var prompt = get_node("Dialog")

func _ready():
	player.prompt = prompt
	player.get_node("AnimationPlayer").play("PlayerIdle")
	enemy.prompt = prompt
	get_node("Dialog/PanelContainer/Container/HBoxContainer/Special").connect("pressed", player, "special", [enemy])
	get_node("Dialog/PanelContainer/Container/HBoxContainer/Attack").connect("pressed", get_node("Player"), "attack", [get_node("Enemy"), player.attck])

