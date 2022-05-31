# Copyright 2022, Frederick Schenk

# --- MainMenu Script ---
# The first menu the player will see.

extends Control

# -- Signals --

# - Signals to Main an new action -
signal move_to_game_options ()


# -- Functions --

# - Moves to the GameOptions -
func _on_start_pressed() -> void:
	emit_signal ("move_to_game_options")

# - Activates the close popup -
func _on_close_button_pressed () -> void:
	get_tree ().notification (MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
