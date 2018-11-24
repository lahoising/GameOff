extends Control

var messages = []
var moving = false
onready var dialog = get_node("PanelContainer/Label")
onready var buttons = get_node("PanelContainer/VBoxContainer")
onready var pLabel = get_node("PanelContainer/VBoxContainer/HBoxContainer2/Attacker")
onready var eLabel = get_node("PanelContainer/VBoxContainer/HBoxContainer2/Target")

func _ready():
	dialog.visible = false
	buttons.visible = true

func _process(delta):
	if (dialog.visible and !moving):
		#print("aqui")
		if messages.size() > 0:
			dialog.text = messages[0]
			dialog.visible_characters += 1
		if (Input.is_action_just_pressed("ui_accept")) or Input.is_action_just_pressed("lclick"):
			
			dialog.visible_characters = 0
			if (messages.size() > 1):
				messages.remove(0)
			else:
				if messages.size() > 0:
					messages.remove(0)
				get_parent().nextState()
				get_parent().attackBtn.grab_focus()

func switch(state):
	#print(messages)
	#print("switch state: "+str(state))
	if state == 2:
		dialog.visible = false
		buttons.visible = false
	elif state == 0:
		dialog.visible = false
		buttons.visible = true
	else:
		dialog.visible = true
		buttons.visible = false