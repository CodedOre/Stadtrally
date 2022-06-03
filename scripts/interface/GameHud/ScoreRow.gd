# Copyright 2022, Frederick Schenk

# --- ScoreRows Script ---
# Displays to the player which points he already got.

extends PanelContainer

# -- Constants --

# - The PackedScene for the ScorePoint -
const POINT_SCENE : PackedScene = preload ("res://scenes/interface/GameHud/ScorePoint.tscn")


# -- Variables --

# - The player this row represents -
var player : KinematicBody


# -- Functions --

# - Sets the player for this row -
func set_player (p_player : KinematicBody, index : int) -> void:
	player = p_player
	$ScoreContainer/PlayerLabel.text = "Spieler " + str (index)

# - Add a new ScorePoint -
func add_score_point (index : int) -> void:
	var point : Control = POINT_SCENE.instance ()
	point.point_index = index
	$ScoreContainer.add_child (point)

# - Get all score points in this row -
func get_score_points () -> Array:
	var output : Array = []
	for child in $ScoreContainer.get_children ():
		if child.is_in_group ("ScorePoint"):
			output.append (output)
	return output

# - Removes all ScorePoints from the row -
func remove_score_points () -> void:
	for child in get_score_points ():
		remove_child (child)
