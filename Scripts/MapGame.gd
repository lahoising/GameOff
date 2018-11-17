extends Control

var table = []
export(int) var rows
export(int) var cols
var target
var thread
onready var selector = $TileMap/Selector
var gridcoor = Vector2()
var nothere = Vector2()

func _ready():
	thread = Thread.new()
	thread.start(self, "_bg_load", "")
	get_tree().paused = true

func _bg_load(path):
	var solution = []
	var row = -1
	var col = -1
	for i in range(rows):
		solution.append([])
		table.append([])
		for j in range(cols):
			solution[i].append(0)
			table[i].append(0)
	
	while true:
		var i = randi()%rows
		var j = randi()%cols
		var val = randi()%(rows*cols)+1
		solution[i][j] = val
		if val == 1:
			row = i
			col = j
		if solve(solution, row, col, 1):
			table[i][j] = val
			nothere = Vector2(i, j)
			break
	
	print(solution)
	print(table)
	var num = 0
	for i in range(rows):
		for j in range(cols):
			$TileMap.get_children()[i*cols+j].text = str(table[i][j])
	
	closeThread()

func closeThread():
	thread.wait_to_finish()
	$TileMap/Selector.visible = true
	$LoadScreen.hide()

func _input(event):
	if event.is_action_pressed("ui_select"):
		closeGame()
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		var dir = Vector2(int(event.is_action_pressed("ui_right")) - int(event.is_action_pressed("ui_left")), int(event.is_action_pressed("ui_down")) - int(event.is_action_pressed("ui_up")))
		if (gridcoor.x + dir.x > -1 and gridcoor.x + dir.x < cols) and gridcoor.y + dir.y > -1 and gridcoor.y + dir.y < rows:
			gridcoor += dir
			var cell_start = $TileMap.world_to_map(selector.position)
			var cell_target = cell_start + dir
			selector.position = $TileMap.map_to_world(cell_target)
			print(gridcoor)
	if event.is_action_pressed("ui_accept"):
		updateTable(1)
	elif event.is_action_pressed("ui_cancel"):
		updateTable(-1)

func updateTable(inc):
	if gridcoor == nothere:
		return
	var label = null
	for child in $TileMap.get_children():
		if child != selector and child.rect_position == selector.position:
			var num = int(child.text)
			if num + inc > 0 and num + inc < rows*cols+1:
				child.text = str(num + inc)
				table[gridcoor.y][gridcoor.x] = num + inc
			elif num + inc > 12:
				child.text = str(1)
				table[gridcoor.y][gridcoor.x] = 1
			else:
				child.text = str(12)
				table[gridcoor.y][gridcoor.x] = 12
			if checkSolve(table, -1, -1, 1):
				print("won")
				closeGame()
			break

func closeGame():
	get_parent().get_parent().get_node("Player").special(target)
	get_tree().paused = false
	queue_free()

func checkSolve(t, posx, posy, c):
	var row = posx
	var col = posy
	if posx < 0:
		for y in range(rows):
			for x in range(cols):
				if t[y][x] == 1:
					row = y
					col = x
					break
			if row > -1:
				break
	
	if c == rows*cols:
		return true
	
	if row < rows-1 and t[row+1][col] == c+1 and checkSolve(t, row+1, col, c+1):
		return true
	elif row > 0 and t[row-1][col] == c+1 and checkSolve(t, row-1, col, c+1):
		return true
	elif col < cols-1 and t[row][col+1] == c+1 and checkSolve(t, row, col+1, c+1):
		return true
	elif col > 0 and t[row][col-1] == c+1 and checkSolve(t, row, col-1, c+1):
		return true
	return false

func solve(t, row, col, c):
	if row == -1 and col == -1:
		for i in range(rows):
			for j in range(cols):
				if t[i][j] == 0:
					if solve(t, i, j, c):
						return true
		return false
	
	t[row][col] = c
	if c == rows*cols:
		return true
	
	if row < rows-1 and t[row+1][col] == c+1 and solve(t, row+1, col, c+1):
		return true
	elif row > 0 and t[row-1][col] == c+1 and solve(t, row-1, col, c+1):
		return true
	elif col < cols-1 and t[row][col+1] == c+1 and solve(t, row, col+1, c+1):
		return true
	elif col > 0 and t[row][col-1] == c+1 and solve(t, row, col-1, c+1):
		return true
	
	for i in range(rows):
		for j in range(cols):
			if row != i and col != j and t[i][j] == c:
				return false
	
	if col > 0 and t[row][col-1] == 0 and solve(t, row, col-1, c+1):
		return true
	elif row > 0 and t[row-1][col] == 0 and solve(t, row-1, col, c+1):
		return true
	elif col < cols-1 and t[row][col+1] == 0 and solve(t, row, col+1, c+1):
		return true
	elif row < rows-1 and t[row+1][col] == 0 and solve(t, row+1, col, c+1):
		return true
	
	t[row][col] = 0
	return false
