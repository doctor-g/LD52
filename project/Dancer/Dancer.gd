extends Node2D

const _LERP_RATE := 0.6

var _knee_left_rot : float
var _knee_right_rot: float
var _hip_left_rot : float
var _hip_right_rot : float
var _shoulder_left_rot : float
var _shoulder_right_rot : float

func _ready():
	_hip_left_rot = $"%Hip_Left".rotation
	_hip_right_rot = $"%Hip_Right".rotation
	_knee_left_rot = $"%Knee_Left".rotation
	_knee_right_rot = $"%Knee_Right".rotation
	_shoulder_left_rot = $"%Shoulder_Left".rotation
	_shoulder_right_rot = $"%Shoulder_Right".rotation
	


func _process(_delta):
	_process_limb_rot("left", $"%Hip_Left", _hip_left_rot, TAU/8)
	_process_limb_rot("right", $"%Hip_Right", _hip_right_rot, -TAU/8)
	_process_limb_rot("left", $"%Knee_Left", _knee_left_rot, -TAU/8)
	_process_limb_rot("right", $"%Knee_Right", _knee_right_rot, TAU/8)
	_process_limb_rot("up", $"%Shoulder_Left", _shoulder_left_rot, -TAU/8)
	_process_limb_rot("down", $"%Shoulder_Right", _shoulder_right_rot, TAU/8)
	

func _process_limb(action:String, node:Node2D, origin:Vector2, offset:Vector2):
	if Input.is_action_pressed(action):
		node.position = lerp(node.position, origin + offset, _LERP_RATE)
	else:
		node.position = lerp(node.position, origin, _LERP_RATE)


func _process_limb_rot(action:String, node:Node2D, origin:float, offset:float):
	if Input.is_action_pressed(action):
		node.rotation = lerp_angle(node.rotation, origin+offset, _LERP_RATE)
	else:
		node.rotation = lerp_angle(node.rotation, origin, _LERP_RATE)

