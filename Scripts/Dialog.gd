extends Control

var messages = []
onready var dialog = get_node("PanelContainer/Container/Label")
onready var buttons = get_node("PanelContainer/Container/HBoxContainer")

func _ready():
	dialog.visible = false
	buttons.visible = true
	pass
	
func _process(delta):
	if (dialog.visible):
		#print("aqui")
		if messages.size() > 0:
			dialog.text = messages[0]
			dialog.visible_characters += 1
		if (Input.is_action_pressed("ui_accept")):
			if (messages.size() > 1):
				dialog.visible_characters = 0
				dialog.text = messages[0]
				messages.remove(0)
			else:
				dialog.visible_characters = 0
				messages.remove(0)
				switch()

func switch():
	if dialog.visible:
		dialog.visible = false
		buttons.visible = true
	else:
		dialog.visible = true
		buttons.visible = false