# Copyright 2022, Frederick Schenk

# --- BoardManager Script ---
# Checks where the player can move to, and the connections on the board.

extends Node

# -- Signals --

# - How many moves the player has taken -
signal moves_taken (moves)


# -- Variables --
# - The id index for the positions in the graph -
var __position_index : Dictionary = {}

# - The graph used for this board -
var __move_graph : AStar = AStar.new ()

# - The currently active player -
var __current_player : KinematicBody = null
var __left_moves : int = 0

# - The positions for each player
var __player_positions : Dictionary = {}

# - Positions the player has already visited
var __visited_positions : Array = []


# -- Functions --

# - Generate the move set for a board -
func generate_move_set () -> void:
	# Add all positions to the graph
	var pos_index : int = 0
	for position in get_tree ().get_nodes_in_group ("Position"):
		pos_index += 1
		__position_index [position] = pos_index
		var pos_origin : Vector3 = position.global_transform.origin
		__move_graph.add_point (pos_index, pos_origin)
	# Connect all points in the graph
	for connection in get_tree ().get_nodes_in_group ("Connection"):
		# Get the positions for the connection
		var position_one : Spatial = connection.get_position_node (1)
		var position_two : Spatial = connection.get_position_node (2)
		# Get the index for these positions
		var pos_one_index : int = __get_index_for_position (position_one)
		var pos_two_index : int = __get_index_for_position (position_two)
		# Create the connection in the graph
		__move_graph.connect_points (pos_one_index, pos_two_index)

# - Get the start position for the players -
func set_start_positions (all_players : Array) -> void:
	# (Temporarly) get just the first position
	var start_pos : Spatial = get_tree ().get_nodes_in_group ("Position") [0]
	for player in all_players:
		move_to_position (player, start_pos)

# - Get all Positions a player could move to -
func get_valid_moves (position : Spatial, moves : int) -> Array:
	# Create our output array
	var all_known_pos : Array = []
	var valid_moves : Array = []
	# Get all valid positions for the moves
	for i in range (moves + 1):
		if i == 0:
			# Get the graph index for the position
			var pos_index : int = __get_index_for_position (position)
			# Set current position on 0 moves
			var self_move : Array = [ pos_index ]
			valid_moves.append (self_move)
			all_known_pos.append_array (self_move)
		else:
			# Get all positions from the earlier step
			var old_moves : Array = valid_moves [i-1]
			var new_moves : Array = []
			# Check all neighbors from the old move set
			for old_pos in old_moves:
				for new_pos in __move_graph.get_point_connections (old_pos):
					# If not already stored then store them
					if not new_pos in all_known_pos and not new_pos in __visited_positions:
						new_moves.append (new_pos)
						all_known_pos.append (new_pos)
			valid_moves.append (new_moves)
	# Return the moves
	return valid_moves

# - Updates the current player from RallyGame -
func update_current_player (player : KinematicBody, moves : int) -> void:
	__current_player = player
	__left_moves = moves
	__visited_positions = []

# - Moves the player to a new position -
func move_to_position (player : KinematicBody, position : Spatial):
	# Set the new position in the storage
	__player_positions [player] = position
	# Set the transform
	__set_player_transforms ()

# - Set players transforms on the position -
func __set_player_transforms () -> void:
	# Check who is on which position
	var position_players : Dictionary = {}
	for player in __player_positions.keys ():
		var position : Spatial = __player_positions [player]
		if not position in position_players.keys ():
			position_players [position] = []
		var pos_players : Array = position_players [position]
		pos_players.append (player)
	# Set the transforms for all players on a position
	for position in position_players.keys ():
		var on_position : Array = position_players [position]
		var on_pos_count : int = len (on_position)
		for i in range (on_pos_count):
			var player : KinematicBody = on_position [i]
			player.global_transform.origin = position.get_player_position (on_pos_count, i)

# - Checks when the player was dragged by PlayerDrag -
func check_player_move (target : Spatial) -> void:
	# Get the start position of the player
	var start_position : Spatial = __player_positions [__current_player]
	# Check if there is a viable target
	if target == null:
		move_to_position (__current_player, start_position)
		return
	# Get the graph index for the positions
	var start_index : int = __get_index_for_position (start_position)
	var target_index : int = __get_index_for_position (target)
	# Get valid move positions from the start position
	var valid_moves : Array = get_valid_moves (start_position, __left_moves)
	# Check if player was dragged to a valid position
	var move_valid : bool = false
	var moves_taken : int = 0
	for i in range (__left_moves + 1):
		var i_moves : Array = valid_moves [i]
		if target_index in i_moves:
			move_valid = true
			moves_taken = i
			break
	# If move not valid, reset to old position
	if not move_valid:
		move_to_position (__current_player, start_position)
		return
	# If move valid, move to the next position
	move_to_position (__current_player, target)
	__left_moves -= moves_taken
	emit_signal ("moves_taken", moves_taken)
	# Exclude taken positions for other turns
	if __left_moves > 0:
		var visited_index : PoolIntArray = __move_graph.get_id_path (start_index, target_index)
		__visited_positions.append_array (visited_index)


# - Get the position node for a graph index -
func __get_position_for_index (index : int) -> Spatial:
	for key in __position_index.keys ():
		if __position_index [key] == index:
			return key
	return null

# - Get the graph index for a position node -
func __get_index_for_position (position : Spatial) -> int:
	return __position_index [position]
