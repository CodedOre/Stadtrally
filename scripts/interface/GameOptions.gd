# Copyright 2022, Frederick Schenk

# --- GameOptions Script ---
# Allows to set options and players for a new game.

extends Control

# -- Signals --

# - Signals to Main an new action -
signal move_to_main_menu ()


# -- Functions --

# - Moves back to the main menu -
func _on_back_pressed() -> void:
	emit_signal ("move_to_main_menu")
