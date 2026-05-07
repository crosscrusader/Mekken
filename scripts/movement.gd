# Process player movement
extends Node
const i = preload("res://scripts/input_handler.gd")
static var direction:i.JOYDIR
var direction_buffer
enum movementState {
	IDLE, 
	JUMPING, 
	FWALK, 
	BWALK, 
	FDASH, 
	BDASH, 
	LSIDEWALK,
	RSIDEWALK,
	LSIDESTEP,
	RSIDESTEP,
}


# We basically want to create an input buffer that updates every frame
static func inputToString(player_buffer:Array[i.JOYDIR]):
	var debug_str:String = ""
	for b in range(0,player_buffer.size()):
		debug_str = debug_str + str(i.JOYDIR.keys()[player_buffer[b]] + ", ")
	return debug_str


static func input_buffer(input_arr:Array[i.JOYDIR], player_direction, buffer_size):
	input_arr.append(player_direction)
	if input_arr.size() > buffer_size:
		input_arr.pop_front()
		
# Allows you to do command normals and special moves
static func checkBuffer(input_arr:Array[i.JOYDIR], buffer:Array[i.JOYDIR]):
	# Compress input buffer to get rid of repeating moves
	var compressed_arr:Array[i.JOYDIR] = [buffer[-1]];
	var debug_str:String;
	
	# Get rid of repeating elements
	for b in range(1,buffer.size()):
		if buffer[-1-b] != buffer[-b]:
			compressed_arr.append(buffer[-1-b])
	compressed_arr.reverse()

	
	# Check if the last few moves in the buffer line up 
	# man i have no idea how to code buffers lol!
	var correctInputCount = 0
	var s = input_arr.size()
	if input_arr[-1] == buffer[-1]:
		if s == 1: # If there is only one input to check
			print("flag1")
			return true
		# If only one input is being held down, 
		elif compressed_arr.size() < s:
			print("flag2")
			return false
		else:
			print(s)
			# Checks subsiquent buffers in order
			for t in range(-2,-s-1,-1):
				
				print(str(t) + "- Input: " + inputToString([input_arr[t]]) + "Compressed Arr: " + inputToString([compressed_arr[t]]))
				if input_arr[t] != compressed_arr[t]:
					print("Array to Check" + inputToString(input_arr))
					print(str(t) + "- Input: " + inputToString([input_arr[t]]) + "Compressed Arr: " + inputToString([compressed_arr[t]]) + "DID NOT WORK!")
					return false
				
	else:
		return false
	
	return true
	
static func checkBufferTap(input:i.JOYDIR, buffer:Array[i.JOYDIR], hold_duration:int):
	var counter = 0
	
	# Only checks on release
	if buffer[-1] == i.JOYDIR.n || buffer.size() > 1:
		if buffer[buffer.size()-2] == input:
			while counter < hold_duration:
				if buffer[-2-counter] == input:
					counter += 1
				else:
					return true
		else:
			return false
	else:
		return false
	
