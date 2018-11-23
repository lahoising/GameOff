extends Control

var messages = []
var moving = false
onready var dialog = get_node("PanelContainer/Container/Label")
onready var buttons = get_node("PanelContainer/Container/HBoxContainer")

func _ready():
	dialog.visible = false
	buttons.visible = true

func _process(delta):
	if (dialog.visible and !moving):
		#print("aqui")
		if messages.size() > 0:
			dialog.text = messages[0]
			dialog.visible_characters += 1
		if (Input.is_action_just_pressed("ui_accept")):
			if (messages.size() > 1):
				dialog.visible_characters = 0
				messages.remove(0)
			else:
				dialog.visible_characters = 0
				messages.remove(0)
				get_parent().nextState()

func switch(state):
	#print(messages)
	#print("switch state: "+str(state))
	if state == 1 or state == 3:
		dialog.visible = true
		buttons.visible = false
	elif state == 0:
		dialog.visible = false
		buttons.visible = true
	else:
		dialog.visible = false
		buttons.visible = false