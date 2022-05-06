# Copyright 2022, Frederick Schenk

# --- Position Script ---
# Data for a single position on the board.

tool
extends Spatial

# -- Enums --

# - What status the position is displaying -
enum FeedbackStatus {
	NONE,
	CURRENT,
	PARTIAL_MOVE,
	FULL_MOVE,
	WRONG
}


# -- Properties --

# - The currently active status -
export (FeedbackStatus) var feedback setget set_feedback, get_feedback

# - The colors assigned to a status -
export (Color, RGB) var color_current
export (Color, RGB) var color_partial_move
export (Color, RGB) var color_full_move
export (Color, RGB) var color_wrong

# - Positions for n players on the Position -
export (Array, PoolVector3Array) var player_positions


# -- Variables --

# - Stores the currently active status -
var __current_feedback : int = FeedbackStatus.NONE


# -- Functions --

# - Run at startup -
func _ready() -> void:
	# Create a new instance of the shader for this position
	var shader_material : ShaderMaterial = ShaderMaterial.new ()
	shader_material.shader = preload ("res://resources/shaders/board/Frame.shader")
	$FrameMesh.set_surface_material (0, shader_material)

# - Return for how many players there are positions available -
func get_max_players () -> int:
	return len (player_positions)

# - Return the origin for players on this position -
func get_player_position (player_sum : int, player_id : int) -> Vector3:
	var array_id : int = player_sum if player_sum < len (player_positions) else len (player_positions)
	var pos_array : PoolVector3Array = player_positions [array_id - 1]
	var pos_id : int = player_id if player_id < len (pos_array) else len (pos_array) - 1
	return global_transform.origin + pos_array [pos_id]

# - Get the feedback status -
func get_feedback () -> int:
	return __current_feedback

# - Set a new feedback status -
func set_feedback (value : int) -> void:
	# Get the material for the frame
	var frame_material : ShaderMaterial = $FrameMesh.get_active_material (0)
	# Adapt the frame for different states
	match value:
		FeedbackStatus.CURRENT:
			__current_feedback = value
			frame_material.set_shader_param ("frame_color", color_current)
		FeedbackStatus.PARTIAL_MOVE:
			__current_feedback = value
			frame_material.set_shader_param ("frame_color", color_partial_move)
		FeedbackStatus.FULL_MOVE:
			__current_feedback = value
			frame_material.set_shader_param ("frame_color", color_full_move)
		FeedbackStatus.WRONG:
			__current_feedback = value
			frame_material.set_shader_param ("frame_color", color_wrong)
		_:
			# Non-recognized values are set to FeedbackStatus.NONE
			__current_feedback = FeedbackStatus.NONE
	# Set the visibility of the frame
	$FrameMesh.visible = not __current_feedback == FeedbackStatus.NONE
