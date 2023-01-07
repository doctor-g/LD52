extends Node2D

const _LERP_RATE := 0.6

var _knee_left_origin : Vector2
var _knee_right_origin : Vector2
var _shoulder_left_rot : float
var _shoulder_right_rot : float

func _ready():
	_knee_left_origin = $"%Knee_Left".position
	_knee_right_origin = $"%Knee_Right".position
	_shoulder_left_rot = $"%Shoulder_Left".rotation
	_shoulder_right_rot = $"%Shoulder_Right".rotation
	


func _process(_delta):
	_process_limb("ui_left", $"%Knee_Left", _knee_left_origin, Vector2(0,-50))
	_process_limb("ui_right", $"%Knee_Right", _knee_right_origin, Vector2(0, -55))
	_process_limb_rot("ui_up", $"%Shoulder_Left", _shoulder_left_rot, -TAU/8)
	_process_limb_rot("ui_down", $"%Shoulder_Right", _shoulder_right_rot, TAU/8)
	
	# Redraw every frame.
	update()


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
	

func _draw():
	_draw_line([$"%Pelvis", $"%Knee_Left", $"%Foot_Left", $"%Toe_Left"])
	_draw_line([$"%Pelvis", $"%Knee_Right", $"%Foot_Right", $"%Toe_Right"])
	_draw_line([$"%Pelvis", $"%Neck", $"%Head"])
	_draw_line([$"%Neck", $"%Shoulder_Left", $"%UpperArm_Left", $"%LowerArm_Left"])
	_draw_line([$"%Neck", $"%Shoulder_Right", $"%UpperArm_Right", $"%LowerArm_Right"])


func _draw_line(nodes:Array):
	var array := []
	for p in nodes:
		var point_in_scene_coordinates : Vector2 = p.global_position - global_position
		array.append(point_in_scene_coordinates)
	draw_polyline(array, Color.black, 5.0, true)
