extends Control

var target
var thread
func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	thread = Thread.new()
	thread.start(self, "_bg_load", "")
	get_tree().paused = true

func _bg_load(path):
	closeThread()

func closeThread():
	if !thread.is_active():
		return
	thread.wait_to_finish()
	$LoadScreen.hide()

func closeGame():
	if not get_tree().paused:
		return
	if thread.is_active():
		closeThread()
	get_parent().get_parent().get_node("Player").special(target)
	get_tree().paused = false
	queue_free()