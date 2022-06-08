# Copyright 2021, Frederick Schenk

# --- GameCamera script ---
# Allows the player to have a good look on the game board.

extends Spatial


# -- Constants --

# - Limits how fast the camera moves -
const CAMERA_MOVE_SPEED : float = 0.02


# -- Nodes --

# - The "gimbal" for the camera
onready var outer_gimbal : Spatial = $OuterGimbal
onready var inner_gimbal : Spatial = $OuterGimbal/InnerGimbal


# -- Functions --

# - Turns the camera according to the retrieved input -
func turn_camera (turn_vector : Vector2) -> void:
	# Get the values into floats (and clamp them when needed)
	var horizontal_move : float = turn_vector.x * CAMERA_MOVE_SPEED
	var vertical_move : float = turn_vector.y * CAMERA_MOVE_SPEED
	# Move each gimbal part into one direction
	outer_gimbal.rotate_object_local (Vector3.UP, horizontal_move)
	inner_gimbal.rotate_object_local (Vector3.RIGHT, vertical_move)
