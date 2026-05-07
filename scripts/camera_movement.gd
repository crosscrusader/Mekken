extends Camera3D
@onready var player1 = $"../Player"
@onready var player2 = $"../Opponent"
#@onready var marker1 = $"../Marker1"
#@onready var marker2 = $"../Marker2"
# The position in between both players on the ground
var player_center_grounded = Vector3();
var v_normalized =  Vector3();
var temp_position = Vector3();
var player_length = 0;
var player_dist_vec = 0;

# Camera Parameters
@export var min_clip = 2
@export var camera_dist = 2;
@export var CameraMovementOn = true



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'ddelta' is the elapsed time since the previous frame.
func _process(_delta):
	if CameraMovementOn:
		player_center_grounded = (player2.position + player1.position)/2

		# Makes sure that the position is grounded
		player_center_grounded = Vector3(player_center_grounded.x, 0, player_center_grounded.z)
		#marker1.position = player_center_grounded
		
		player_dist_vec = (player1.position - player2.position)
		player_length = abs(player_dist_vec.length())
		
		# Calculate Vector Normal
		v_normalized = Vector3(-(player2.position - player1.position).z, 0, (player2.position - player1.position).x)
		v_normalized = v_normalized.normalized()
		if player_length >= min_clip:
			position = v_normalized*player_length + player_center_grounded
		else:
			position = v_normalized*min_clip + player_center_grounded
		position.y = 2
		
		# Position Camera 2 player_lengths away
		rotation = Vector3(0,atan2(v_normalized.x, v_normalized.z),0)
	
