# Copyright 2022, Frederick Schenk

# --- PlayerDrag Script ---
# Manages drag and drop actions of an player.

extends Node

# -- Variables --

# - The currently dragged player -
var __dragged_player : KinematicBody = null


# -- Functions --

# - Begins the drag action -
func drag_player (player : KinematicBody) -> void:
	pass

# - Move the player while dragging -
func move_player (position : Vector3) -> void:
	pass

# - Stops the drag action -
func drop_player (player : KinematicBody) -> void:
	pass
