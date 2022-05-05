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
signal player_dropped ()


# -- Variables --

# - The currently active input mode -
var __input_mode : int = InputMode.NONE


# -- Functions --

# - Handle input events -
func _input(event: InputEvent) -> void:
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
		emit_signal ("player_dragged", event_target)

# - Run when a drag is active -
func __on_mouse_left_moving (event : InputEvent) -> void:
	# Get the position the mouse is pointing at
	var pointer : Vector3 = __get_targeted_position (event.position)
	# And return it in the signal
	emit_signal ("player_moved", pointer)

# - Run when a drag with the left mouse button was stopped -
func __on_mouse_left_drop () -> void:
	# Note the action without attached player
	emit_signal ("player_dropped")

# - Get what the mouse is pointing at -
func __get_mouse_pointing (screen_pos : Vector2, ignore_players : bool = false) -> Dictionary:
	# Get the active camera
	var camera : Camera = get_viewport ().get_camera ()
	# Get ray origin and normal
	var ray_origin : Vector3 = camera.project_ray_origin (screen_pos)
	var ray_normal : Vector3 = ray_origin + camera.project_ray_normal (screen_pos) * MOUSE_RAYCAST_LENGTH
	# Get the world space
	var space_state = get_world ().direct_space_state
	# Set which collision masks should be ignored (like players when dragging)
	var mask_bit : int = 1 if ignore_players else 3
	# Cast the raycast
	return space_state.intersect_ray (ray_origin, ray_normal, [], mask_bit)

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
	var raycast : Dictionary = __get_mouse_pointing (screen_pos, true)
	# If no position could be determined
	if len (raycast) == 0:
		# Return an infinite vector
		return Vector3.INF
	# Return the determined position
	return raycast.position
