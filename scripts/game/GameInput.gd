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
