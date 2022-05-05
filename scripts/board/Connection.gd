# Copyright 2022, Frederick Schenk

# --- Connection Script ---
# Handles a way a player can move between two positions.

tool
extends Node

# -- Properties --

# - The two connected positions -
export (NodePath) onready var position_1 setget set_position_1, get_position_1
export (NodePath) onready var position_2 setget set_position_2, get_position_2


# -- Variables --

# - The two connected positions -
onready var __position_1 : NodePath
onready var __position_2 : NodePath


# -- Functions --

# - Run at startup -
func _ready() -> void:
	# Create new curve for new instances
	$Line.curve = Curve3D.new ()
	__render_line ()

# - Gets one of the two positions -
func get_position_1 () -> NodePath:
	return __position_1

func get_position_2 () -> NodePath:
	return __position_2

# - Sets one of the two positions -
func set_position_1 (path : NodePath) -> void:
	__position_1 = path
	if Engine.editor_hint:
		__render_line ()

func set_position_2 (path : NodePath) -> void:
	__position_2 = path
	if Engine.editor_hint:
		__render_line ()

# - Get the node behind the positions -
func get_position_node (index : int) -> Node:
	match index:
		1:
			return get_node (__position_1)
		2:
			return get_node (__position_2)
		_:
			push_error ("Invalid position index!")
			return null

# - Sets the line for the connection -
func __render_line () -> void:
	# Don't draw a line when one or more positions are undefined
	if __position_1.is_empty () or __position_2.is_empty ():
		$Line.curve.clear_points ()
		return
	# We want two unique positions
	if __position_1 == __position_2:
		push_error ("One Position on both properties!")
		$Line.curve.clear_points ()
		return
	if is_inside_tree ():
		# Get the nodes behind the paths
		var pos_1 : Spatial = get_position_node (1)
		var pos_2 : Spatial = get_position_node (2)
		# Set the points for the 3D line
		$Line.curve.clear_points ()
		$Line.curve.add_point (pos_1.global_transform.origin)
		$Line.curve.add_point (pos_2.global_transform.origin)
