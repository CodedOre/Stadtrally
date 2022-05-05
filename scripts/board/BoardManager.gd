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

# - Get all Positions a player could move to -
func get_valid_moves (position : Spatial, moves : int) -> Array:
	# Create our output array
	var all_known_pos : Array = []
	var valid_moves : Array = []
	# Get all valid positions for the moves
	for i in range (moves + 1):
		if i == 0:
			# Set current position on 0 moves
			var self_move : Array = [ position ]
			valid_moves.append (self_move)
			all_known_pos.append_array (self_move)
		else:
			# Get all positions from the earlier step
			var old_moves : Array = valid_moves [i-1]
			var new_moves : Array = []
			# Check all neighbors from the old move set
			for old_pos in old_moves:
				for new_pos in __move_set.get (old_pos, []):
					# If not already stored then store them
					if not new_pos in all_known_pos:
						new_moves.append (new_pos)
						all_known_pos.append (new_pos)
			valid_moves.append (new_moves)
	# Return the moves
	return valid_moves
