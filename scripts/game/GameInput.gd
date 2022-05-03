# Copyright 2022, Frederick Schenk

# --- GameInput Script ---
# Handling input from the user and the corresponding actions.

extends Spatial

# -- Enums --

# - Input modi that can be active -
enum InputMode {
	NONE,
	SELECTION,
	DRAG
}


# -- Constants --

# - How long the distance of the mouse ray cast should be -
const MOUSE_RAYCAST_LENGTH : int = 1000


# -- Variables --

# - The currently active input mode -
var __input_mode : int = InputMode.NONE

# - Determine current events -
var __mouse_left_clicked : bool = false
var __mouse_left_held : bool = false


# -- Functions --

# - Handle input events -
func _unhandled_input(event: InputEvent) -> void:
	# Handle mouse button events
	if event is InputEventMouseButton:
		# Left click (select or drag player)
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				# Note button click, but no action yet
				__mouse_left_clicked = true
			else:
				if __mouse_left_held:
					# Finalize drag input
					__mouse_left_held = false
					__on_mouse_left_drop (event)
				else:
					# Finalize click input
					__mouse_left_clicked = false
					__on_mouse_left_click (event)
	# Handle mouse motion events
	if event is InputEventMouseMotion:
		# If motion while left mouse button is pressed
		if __mouse_left_clicked:
			# Activate mouse drag input
			__mouse_left_clicked = false
			__mouse_left_held = true
			__on_mouse_left_drag (event)

# - Run when a left mouse button click was detected -
func __on_mouse_left_click (event : InputEvent) -> void:
	pass

# - Run when a drag with the left mouse button was started -
func __on_mouse_left_drag (event : InputEvent) -> void:
	pass

# - Run when a drag with the left mouse button was stopped -
func __on_mouse_left_drop (event : InputEvent) -> void:
	pass

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
