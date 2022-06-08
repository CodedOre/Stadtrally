# Copyright 2021, Frederick Schenk

# --- GameCamera script ---
# Allows the player to have a good look on the game board.

extends Spatial


# -- Constants --

# - Limits how far you can zoom -
const MIN_CAMERA_ZOOM : float = 15.0
const MAX_CAMERA_ZOOM : float = 75.0
const CAMERA_ZOOM_RANGE : float = MAX_CAMERA_ZOOM - MIN_CAMERA_ZOOM

# - Min/Max for the vertical rotations determined by the zoom curve -
const MIN_VERTICAL_ROTATION : float = deg2rad (-90.0)
const MAX_VERTICAL_ROTATION : float = deg2rad (-15.0)
const VERTICAL_ROTATION_RANGE : float = MAX_VERTICAL_ROTATION - MIN_VERTICAL_ROTATION

# - Limits how fast the camera moves -
const CAMERA_MOVE_SPEED : float = 0.65
const CAMERA_TURN_SPEED : float = 0.02


# -- Nodes --

# - The "gimbal" for the camera
onready var outer_gimbal : Spatial = $OuterGimbal
onready var inner_gimbal : Spatial = $OuterGimbal/InnerGimbal
onready var camera_node : Camera = $OuterGimbal/InnerGimbal/Camera


# -- Properties --

# - The curve determening the angle on a certain zoom -
export (Curve) var zoom_curve : Curve

# - The limits for the camera movement -
export (Vector2) var move_bounds : Vector2


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
	# Get the basis of the outer gimbal (as this defines where is forward)
	var gimbal_basis = outer_gimbal.global_transform.basis
	# Apply the movement vectors to the normalized basis
	var x_movement : Vector3 = gimbal_basis.x.normalized () * movement_vector.x
	var y_movement : Vector3 = gimbal_basis.z.normalized () * movement_vector.y
	# Move the camera
	translate (x_movement + y_movement)
	# Keep the camera inside the set bounds
	transform.origin.x = clamp (transform.origin.x, -1.0 * move_bounds.x, move_bounds.x)
	transform.origin.z = clamp (transform.origin.z, -1.0 * move_bounds.y, move_bounds.y)

# - Turns the camera according to the retrieved input -
func turn_camera (turn_angle : float) -> void:
	# Get the values into floats (and clamp them when needed)
	var horizontal_move : float = turn_angle * CAMERA_TURN_SPEED
	# Move each gimbal part into one direction
	outer_gimbal.rotate_object_local (Vector3.UP, horizontal_move)

# - Zooms the camera in or out -
func zoom_camera (direction : float) -> void:
	# Clamp the zoom with the existing transform
	var camera_pos : Vector3 = camera_node.transform.origin
	var zoomed_pos : float = clamp (camera_pos.z + direction, MIN_CAMERA_ZOOM, MAX_CAMERA_ZOOM)
	var zoom_move : float = zoomed_pos - camera_pos.z
	# Move the camera node using the zoom
	camera_node.translate (Vector3 (0.0, 0.0, zoom_move))
	# Get the relative amount of our zoom in relation to min/max
	var zoom_range : float = zoomed_pos - MIN_CAMERA_ZOOM
	var zoom_amount : float = zoom_range / CAMERA_ZOOM_RANGE
	# Get the equivalent relative rotation from the curve
	var curve_rotation : float = zoom_curve.interpolate (zoom_amount)
	# Convert the relative rotation to a transform and apply it to the inner gimbal
	var vertical_rotation : float = (curve_rotation * VERTICAL_ROTATION_RANGE) + MIN_VERTICAL_ROTATION
	inner_gimbal.rotation.x = vertical_rotation
