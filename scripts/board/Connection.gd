# Copyright 2022, Frederick Schenk

# --- Connection Script ---
# Handles a way a player can move between two positions.

extends Node

# -- Properties --

# - The two connected positions -
export (NodePath) onready var position_1
export (NodePath) onready var position_2
