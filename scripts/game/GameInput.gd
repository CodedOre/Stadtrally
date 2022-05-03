# Copyright 2022, Frederick Schenk

# --- GameInput Script ---
# Handling input from the user and the corresponding actions.

extends Spatial

# -- Enums --

# - Input modi that can be active -
enum InputMode {
	NONE,
	MOUSE_LEFT_CLICK,
	MOUSE_LEFT_DRAG
}


# -- Constants --

# - How long the distance of the mouse ray cast should be -
const MOUSE_RAYCAST_LENGTH : int = 1000


# -- Signals --

# - Signals Position input actions -
signal position_selected (position)

# - Signals Player input actions -
signal player_selected (player)
signal player_dragged (player)
signal player_moved (position)
signal player_dropped (player)


# -- Variables --

# - The currently active input mode -
var __input_mode : int = InputMode.NONE

# - The dragged player -
var __dragged_player : KinematicBody = null


# -- Functions --

# - Handle input events -
func _unhandled_input(event: InputEvent) -> void:
	# Handle mouse button events
	if event is InputEventMouseButton:
		# Left click (select or drag player)
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				# Note button click, but no action yet
				__input_mode = InputMode.MOUSE_LEFT_CLICK
			else:
				if __input_mode == InputMode.MOUSE_LEFT_DRAG:
					# Finalize drag input
					__input_mode = InputMode.NONE
					__on_mouse_left_drop ()
				if __input_mode == InputMode.MOUSE_LEFT_CLICK:
					# Finalize click input
					__input_mode = InputMode.NONE
					__on_mouse_left_click (event)
	# Handle mouse motion events
	if event is InputEventMouseMotion:
		# If motion when mouse button just clicked
		if __input_mode == InputMode.MOUSE_LEFT_CLICK:
			# Activate mouse drag input
			__input_mode = InputMode.MOUSE_LEFT_DRAG
			__on_mouse_left_drag (event)
		# If motion when dragging player
		if __input_mode == InputMode.MOUSE_LEFT_DRAG:
			__on_mouse_left_moving (event)

# - Run when a left mouse button click was detected -
func __on_mouse_left_click (event : InputEvent) -> void:
	# Get what which object was clicked
	var event_target : Node = __get_targeted_item (event.position)
	# Check if a player was clicked
	if event_target.is_in_group ("Player"):
		emit_signal ("player_selected", event_target)
	# Check if a position was clicked
	if event_target.is_in_group ("Position"):
		emit_signal ("position_selected", event_target)

# - Run when a drag with the left mouse button was started -
func __on_mouse_left_drag (event : InputEvent) -> void:
	# Get what which object was clicked
	var event_target : Node = __get_targeted_item (event.position)
	# Check if a player was clicked
	if event_target.is_in_group ("Player"):
		# Store the dragged player for the drop event
		__dragged_player = event_target
		emit_signal ("player_dragged", __dragged_player)

# - Run when a drag is active -
func __on_mouse_left_moving (event : InputEvent) -> void:
	# Get the position the mouse is pointing at
	var pointer : Vector3 = __get_targeted_position (event.position)
	# And return it in the signal
	emit_signal ("player_moved", pointer)

# - Run when a drag with the left mouse button was stopped -
func __on_mouse_left_drop () -> void:
	# Drop if an player is noted to be dragged
	if __dragged_player != null:
		__dragged_player = null
		emit_signal ("player_dropped")

# - Get what the mouse is pointing at -
func __get_mouse_pointing (screen_pos : Vector2) -> Dictionary:
	# Get the active camera
	var camera : Camera = get_viewport ().get_camera ()
	# Get ray origin and normal
	var ray_origin : Vector3 = camera.project_ray_origin (screen_pos)
	var ray_normal : Vector3 = ray_origin + camera.project_ray_normal (screen_pos) * MOUSE_RAYCAST_LENGTH
	# Cast the raycast
	var space_state = get_world ().direct_space_state
	return space_state.intersect_ray (ray_origin, ray_normal)

# - Get the Player/Position targeted by an click -
func __get_targeted_item (screen_pos : Vector2) -> Node:
	# Get the result of what the mouse is pointing at
	var raycast : Dictionary = __get_mouse_pointing (screen_pos)
	# Return null if raycast didn't hit anything
	if len (raycast) == 0:
		return null
	# Check which object we hit
	var node : Node = raycast.collider
	return node

# - Get the position where the mouse is pointing at -
func __get_targeted_position (screen_pos : Vector2) -> Vector3:
	# Get the result of what the mouse is pointing at
	var raycast : Dictionary = __get_mouse_pointing (screen_pos)
	# If no position could be determined
	if len (raycast) == 0:
		# If no player is dragged return a zero vector
		if __dragged_player == null:
			return Vector3.ZERO
		# If a player is dragged return it's position
		else:
			return __dragged_player.global_transform.origin
	# Return the determined position
	return raycast.position
