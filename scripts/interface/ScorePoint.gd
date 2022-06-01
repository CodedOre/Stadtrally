# Copyright 2022, Frederick Schenk

# --- ScorePoint Script ---
# A small widget showing the progress for one question.

tool
extends MarginContainer

# -- Properties --

# - The index for this point -
export (int) var point_index setget set_point_index, get_point_index

# - If the point was given -
export (bool) var point_given setget set_point_given, get_point_given


# -- Variables --

# - Stores the point index -
var _point_index : int = 0


# -- Functions --

# - Gets the point index -
func get_point_index () -> int:
	return _point_index

# - Sets the point index -
func set_point_index (value : int) -> void:
	_point_index = value
	$LabelMargin/PointLabel.text = str (_point_index)

# - Gets if the point was given -
func get_point_given () -> bool:
	return $SolvedTexture.visible

# - Sets if the point was given -
func set_point_given (value : bool) -> void:
	$SolvedTexture.visible = value
