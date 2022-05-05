# Copyright 2022, Frederick Schenk

# --- Position Script ---
# Data for a single position on the board.

extends Spatial

# -- Properties --

# - Positions for n players on the Position -
export (Array, PoolVector3Array) var player_positions


# -- Functions --

# - Return for how many players there are positions available -
func get_max_players () -> int:
	return len (player_positions)

# - Return the origin for players on this position -
func get_player_position (player_sum : int, player_id : int) -> Vector3:
	var array_id : int = player_sum if player_sum < len (player_positions) else len (player_positions)
	var pos_array : PoolVector3Array = player_positions [array_id - 1]
	var pos_id : int = player_id if player_id < len (pos_array) else len (pos_array) - 1
	return global_transform.origin + pos_array [pos_id]
