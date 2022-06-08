# Copyright 2021, Frederick Schenk

# --- GameCamera script ---
# Allows the player to have a good look on the game board.

extends Spatial


# -- Constants --

# - Limits how fast the camera moves -
const CAMERA_MOVE_SPEED : float = 0.65
const CAMERA_TURN_SPEED : float = 0.02


# -- Nodes --

# - The "gimbal" for the camera
onready var outer_gimbal : Spatial = $OuterGimbal
onready var inner_gimbal : Spatial = $OuterGimbal/InnerGimbal
onready var camera_node : Camera = $OuterGimbal/InnerGimbal/Camera


# -- Functions --

# - Runs at every frame -
func _process (_delta: float) -> void:
	# Create movement vector
	var movement_vector : Vector2 = Vector2 (0.0, 0.0)
	# Retrieve input for movement
	if Input.is_action_pressed ("camera_move_up"):
		movement_vector += Vector2 (0.0, -CAMERA_MOVE_SPEED)
	if Input.is_action_pressed ("camera_move_down"):
		movement_vector += Vector2 (0.0, CAMERA_MOVE_SPEED)
	if Input.is_action_pressed ("camera_move_left"):
		movement_vector += Vector2 (-CAMERA_MOVE_SPEED, 0.0)
	if Input.is_action_pressed ("camera_move_right"):
		movement_vector += Vector2 (CAMERA_MOVE_SPEED, 0.0)
	# Move the camera
	translate (Vector3 (movement_vector.x, 0.0, movement_vector.y))

# - Turns the camera according to the retrieved input -
func turn_camera (turn_angle : float) -> void:
	# Get the values into floats (and clamp them when needed)
	var horizontal_move : float = turn_angle * CAMERA_TURN_SPEED
	# Move each gimbal part into one direction
	outer_gimbal.rotate_object_local (Vector3.UP, horizontal_move)

# - Zooms the camera in or out -
func zoom_camera (direction : float) -> void:
	camera_node.translate (Vector3 (0.0, 0.0, direction))
