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


# -- Functions --

# - Handle input events -
func _unhandled_input(event: InputEvent) -> void:
	pass
