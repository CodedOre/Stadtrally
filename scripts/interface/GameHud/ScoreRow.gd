# Copyright 2022, Frederick Schenk

# --- ScoreRows Script ---
# Displays to the player which points he already got.

extends PanelContainer

# -- Constants --

# - The PackedScene for the ScorePoint -
const POINT_SCENE : PackedScene = preload ("res://scenes/interface/GameHud/ScorePoint.tscn")


# -- Functions --

# - Add a new ScorePoint -
func add_score_point (index : int) -> void:
	var point : Control = POINT_SCENE.instance ()
	point.point_index = index
	$ScoreContainer.add_child (point)

# - Removes all ScorePoints from the row -
func remove_score_points () -> void:
	for child in $ScoreContainer.get_children ():
		if child.is_in_group ("ScorePoint"):
			remove_child (child)
