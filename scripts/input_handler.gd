# This script serves as a library that gets referenced by other scripts
# probably, I have no idea how to code lmao

extends Node
enum JOYDIR {f, b, u, d, df, db, uf, ub, n, NULL}
var joystr:Array[String] = ['f', 'b', 'u', 'd', 'df', 'db', 'uf', 'ub', 'n']


static func buffer(buffer_size):
	pass

# Translates inputs into directions in movements 
# This function will be called in each player script, probably
static func input2movement():
	var direction
	# Handles multiple inputs pressed simultaniously 
	if Input.is_action_pressed("down") and Input.is_action_pressed("right"):
		direction = JOYDIR.df
	elif Input.is_action_pressed("down") and Input.is_action_pressed("left"):
		direction = JOYDIR.db
	elif Input.is_action_pressed("up") and Input.is_action_pressed("right"):
		direction = JOYDIR.uf
	elif Input.is_action_pressed("up") and Input.is_action_pressed("left"):
		direction = JOYDIR.ub
		
	# Handles a single input being pressed
	elif Input.is_action_pressed("right"):
		if Input.is_action_pressed("left"):
			direction = JOYDIR.n
		else:
			direction = JOYDIR.f
		
	elif Input.is_action_pressed("left"):
		if Input.is_action_pressed("right"):
			direction = JOYDIR.n
		else:
			direction = JOYDIR.b
	elif Input.is_action_pressed("up"):
		if Input.is_action_just_pressed("down"):
			direction = JOYDIR.n
		else:
			direction = JOYDIR.u
	elif Input.is_action_pressed("down"):
		if Input.is_action_just_pressed("up"):
			direction = JOYDIR.n
		else:
			direction = JOYDIR.d
	else:
		direction = JOYDIR.n
			
	return direction
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	# Reads input all 8 input directions

	
	#text = "Input: " + joystr[currentState]
		
	
