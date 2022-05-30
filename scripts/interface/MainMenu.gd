# Copyright 2022, Frederick Schenk

# --- MainMenu Script ---
# The first menu the player will see.

extends Control

# -- Functions --

# - Activates the close popup -
func _on_close_button_pressed () -> void:
	get_tree ().notification (MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
