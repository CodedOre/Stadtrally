# Copyright 2022, Frederick Schenk

# --- BoardManager Script ---
# Checks where the player can move to, and the connections on the board.

extends Node

# -- Variables --

# - The move-set for this board -
var __move_set : Dictionary = {}


# -- Functions --

# - Generate the move set for a board -
func generate_move_set () -> void:
	var new_move_set : Dictionary = {}
	# Parse through all connections
	for connection in get_tree ().get_nodes_in_group ("Connection"):
		# Get the positions for the connection
		var position_one : Spatial = connection.get_position_node (1)
		var position_two : Spatial = connection.get_position_node (2)
		# Check if they are positions
		if not position_one.is_in_group ("Position") or not position_two.is_in_group ("Position"):
			push_error ("Connections should be between two Positions!")
			return
		# Get (or create) an neighbor array for the positions
		if not position_one in new_move_set.keys ():
			new_move_set [position_one] = []
		var pos_one_neighbors : Array = new_move_set [position_one]
		if not position_two in new_move_set.keys ():
			new_move_set [position_two] = []
		var pos_two_neighbors : Array = new_move_set [position_two]
		# Add the neighbor if not already in it
		if not position_two in pos_one_neighbors:
			pos_one_neighbors.append (position_two)
		if not position_one in pos_two_neighbors:
			pos_two_neighbors.append (position_one)
	# Set the move set to the new dictionary
	__move_set = new_move_set
