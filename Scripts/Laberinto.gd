extends "games.gd"

onready var map = $Navigation2D/TileMap
onready var nav = $Navigation2D
onready var pawn = $Pawn
onready var timer = $Timer
export(int) var spd
var path = []
var right = 0
var left = 0
var up = 0
var down = 0

func _bg_load(path):
	createMap()
	._bg_load(path)

func createMap():
	randomize()
	var nothere = []
	var path = []
	nothere.append(Vector2(0,9))
	nothere.append(Vector2(11,0))
	for y in range(ProjectSettings.get_setting("display/window/size/height")/map.cell_size.y):
		for x in range(ProjectSettings.get_setting("display/window/size/width")/map.cell_size.x):
			if randi()%3 == 0 and !(Vector2(x,y) in nothere):
				map.set_cell(x,y,1)
			else:
				map.set_cell(x,y,0)

func _input(event):
	if event.is_action_pressed("ui_select"):
		print("here")
		closeGame()
	
	if event.is_action_pressed("ui_right"):
		right = 1
	if event.is_action_pressed("ui_left"):
		left = 1
	if event.is_action_pressed("ui_up"):
		up = 1
	if event.is_action_pressed("ui_down"):
		down = 1
	
	if event.is_action_released("ui_right"):
		right = 0
	if event.is_action_released("ui_left"):
		left = 0
	if event.is_action_released("ui_up"):
		up = 0
	if event.is_action_released("ui_down"):
		down = 0

func _physics_process(delta):
	var xdir = right - left
	var ydir = down - up
	var motion = Vector2(xdir, ydir) * spd
	pawn.move_and_slide(motion)
	
	if path.size() <= 0:
		path = nav.get_simple_path($End.global_position, $Start.global_position, false)
		if path.size() <= 0 and !thread.is_active():
			thread.start(self, "_bg_load", "")
	
	if map.world_to_map(pawn.global_position) == map.world_to_map($End.global_position):
		closeGame()
