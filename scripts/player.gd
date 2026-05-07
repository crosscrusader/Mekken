extends CharacterBody3D
const i = preload("res://scripts/input_handler.gd")
const j = i.JOYDIR
const m = preload("res://scripts/movement.gd")

@onready var anim = $alpha_proto_v2/AnimationPlayer
@onready var marker = $"../Marker2"
@onready var target = $"../Opponent"
@onready var radius_vec:Vector3
@onready var r:float # Radius
@export var walk_speed = 3.0
static var currentState: m.movementState
@export var buffer_size = 12
var target_position
const JUMP_VELOCITY = 4.5
static var player_buffer:Array[j]
var last_input_buffer:Array[j]
static var currentInputDirection: i.JOYDIR

# Movement Variables
@export var dash_multiplier = 2
@export var bdash_multiplier = 2


# The best type of variables hahahaha hehehehe
var debug_str:String
var frame_counter:int
var globalFrameCounter:int
var globalCooldown:int
@export var sideCooldown = 24
@export var fdashCooldown = 20
var coolDownTimeout = true
@export var sideStepSpeed = 5


# Our default forward direction is +x, but it can change on where the character
# side-steps or changes sides from right to left
var forward_direction:Vector3 = Vector3(0, 0, 1)
var angle = 0


func ready():
	print("hello!")
	globalFrameCounter = 0
	# Put one input in the buffer for debugging purposes
	player_buffer[1] = j.n
	
	basis.x
	for v in range(10,0,-1):
		print(v)
		print("\n")
	
	# Fill up buffer so we don't get errors lol
	for i in range(0,buffer_size):
		player_buffer.append(j.n)
	
	for b in range(0,player_buffer.size()):
			debug_str = debug_str + str(i.JOYDIR.keys()[player_buffer[b]] + ", ")
	print(debug_str)
	
		
		
func cooldown():
	pass
	

func return_to_neutral(testInput:Array[j]):
	if !m.checkBuffer(testInput, player_buffer):
		currentState = m.movementState.IDLE

func _physics_process(delta):
	globalFrameCounter += 1
	last_input_buffer = player_buffer.duplicate()
	
	# Character Rotation Math
	target_position = Vector3(target.position.x, 0, target.position.z) 
	radius_vec = position - target.position
	radius_vec.y = 0
	r = radius_vec.length() 
	
	# Update forward direction
	forward_direction = Vector3(target.position.x - position.x, 0, target.position.z - position.z).normalized()
	
	# Rotate the darn character
	position = Vector3(r * cos(angle) + target.position.x,0,r * sin(angle) + target.position.z)
	look_at(Vector3(target_position.x, 0, target.position.z), Vector3.UP)

	rotate(Vector3.UP,PI)
	
	# Get current input
	currentInputDirection = i.input2movement()	
	
	# Run input buffer
	m.input_buffer(player_buffer, currentInputDirection, buffer_size)
	
	# State Machine
	# Current Issue: You can't transition from back to 
	match (currentState):
		m.movementState.IDLE:
			# Play animation
			anim.play("Neutral")
			# All states branch from this one 
			if m.checkBuffer([j.f,j.n,j.f], player_buffer):
				currentState = m.movementState.FDASH
				globalCooldown = globalFrameCounter
			elif m.checkBuffer([j.b,j.n,j.b], player_buffer):
				currentState = m.movementState.BDASH
				globalCooldown = globalFrameCounter
			elif m.checkBuffer([j.f], player_buffer):
				currentState = m.movementState.FWALK
			elif m.checkBuffer([j.b], player_buffer):
				currentState = m.movementState.BWALK
			elif m.checkBufferTap(j.u, player_buffer,6):
				currentState = m.movementState.RSIDESTEP
				# Start cooldown
				globalCooldown = globalFrameCounter
			elif m.checkBufferTap(j.d, player_buffer,6):
				currentState = m.movementState.LSIDESTEP
				globalCooldown = globalFrameCounter
		m.movementState.JUMPING:
			pass
		m.movementState.FDASH:
			anim.play("forward_dash")
			position += forward_direction * walk_speed * delta * dash_multiplier
			if fdashCooldown <= globalFrameCounter - globalCooldown:
				currentState = m.movementState.IDLE
			# We want to enter a cooldown after we forward dash
		m.movementState.FWALK:
			position += forward_direction * walk_speed * delta
			anim.play("Forward_walk")
			return_to_neutral([j.f])
		m.movementState.BWALK:
			position -= forward_direction * 2*walk_speed/3  * delta
			anim.play("Back_walk")
			return_to_neutral([j.b])
		m.movementState.BDASH:
			anim.play("forward_dash")
			position -= forward_direction * walk_speed * delta * bdash_multiplier
			if fdashCooldown <= globalFrameCounter - globalCooldown:
				currentState = m.movementState.IDLE
		m.movementState.LSIDEWALK:
			angle -= delta  * sideStepSpeed/r
			anim.play("side_walk_right")
			return_to_neutral([j.d])
		m.movementState.RSIDEWALK:
			angle += delta * sideStepSpeed/r
			anim.play("side_walk_left")
			return_to_neutral([j.u])
		m.movementState.LSIDESTEP:
			angle -= delta * 2  * sideStepSpeed/r
			anim.play("side_step_right")
			#print(globalCooldown)
			if sideCooldown <= globalFrameCounter - globalCooldown:
				currentState = m.movementState.LSIDEWALK
			# If animation finishes and up is still pressed
			# transition to Lsidewalk animation
		m.movementState.RSIDESTEP:
			angle += delta * 2  * sideStepSpeed/r
			anim.play("side_step_left")
			#print(globalFrameCounter - globalCooldown)
			if sideCooldown <= globalFrameCounter - globalCooldown:
				currentState = m.movementState.RSIDEWALK

	## Handles forwards and backwards movement
	#if Input.is_anything_pressed():
		#if Input.is_action_pressed("right"):
			#position += forward_direction * walk_speed * delta
			#anim.play("Forward_walk")
		#if Input.is_action_pressed("left"):
			#position -= forward_direction * 2*walk_speed/3  * delta
			#anim.play("Back_walk")
		#if Input.is_action_pressed("up"):
			#angle += delta
			#anim.play("Dash")
		#if Input.is_action_pressed("down"):
			#angle -= delta
			#anim.play("side_walk_right")
		#
	#else:
		#velocity = Vector3.ZERO
		#anim.play("Neutral")
	#
	position.y = 0
	
	move_and_slide()
	# Print buffer if there's any change
	if last_input_buffer != player_buffer:
		for b in range(0,player_buffer.size()):
			debug_str = debug_str + str(i.JOYDIR.keys()[player_buffer[b]] + ", ")
		if (currentInputDirection == j.f) && (currentState == m.movementState.BWALK) ||  (currentInputDirection == j.b) && (currentState == m.movementState.FWALK):
			debug_str = debug_str + " GLITCH!"
		debug_str = debug_str + " " + str(frame_counter) + " "
		#print(debug_str)
		frame_counter = 0
	else:
		frame_counter += 1
	debug_str = ""
