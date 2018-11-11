extends Control

var table = []
var rows = 3
var cols = 4
var target

func _ready():
	
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
			break
	print(solution)
	var num = 0
	for i in range(rows):
		for j in range(cols):
			$TileMap.get_children()[i*cols+j].text = str(table[i][j])
	
	get_tree().paused = true

func _input(event):
	if event.is_action_pressed("ui_select"):
		get_parent().get_parent().get_node("Player").special(target)
		get_tree().paused = false
		queue_free()

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