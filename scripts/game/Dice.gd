# Copyright 2022, Frederick Schenk

# --- Dice Script ---
# Generates a random number for the player.

extends Node

# -- Variables --

# - The random number generator -
var __random : RandomNumberGenerator


# -- Functions --

# - Run on startup -
func _ready () -> void:
	# Initializes the random number generator
	__random = RandomNumberGenerator.new ()
	__random.randomize ()

# - Rolls the dice for a number -
func roll_dice () -> int:
	return __random.randi_range(1, 6)
