extends Label
const p = preload("res://scripts/player.gd")
const i = preload("res://scripts/input_handler.gd")
const m = preload("res://scripts/movement.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Hello World!"
	show()
	 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Input: " + i.JOYDIR.keys()[p.player_buffer[-1]] + "\n" + m.movementState.keys()[p.currentState]
