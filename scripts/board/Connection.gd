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
onready var __position_1 : StaticBody = null
onready var __position_2 : StaticBody = null


# -- Functions --

# - Run at startup -
func _ready() -> void:
	# Create new curve for new instances
	$Line.curve = Curve3D.new ()

# - Gets one of the two positions -
func get_position_1 () -> NodePath:
	return __position_1.get_path () if __position_1 != null else ""

func get_position_2 () -> NodePath:
	return __position_2.get_path () if __position_2 != null else ""

# - Sets one of the two positions -
func set_position_1 (path : NodePath) -> void:
	if not path.is_empty ():
		var node : Node = get_node (path)
		if node.is_in_group ("ClassPosition"):
			__position_1 = node
		else:
			__position_1 = null
			push_error ("Connection can only retrieve a Position node!")
	else:
		__position_1 = null
	__render_line ()

func set_position_2 (path : NodePath) -> void:
	if not path.is_empty ():
		var node : Node = get_node (path)
		if node.is_in_group ("ClassPosition"):
			__position_2 = node
		else:
			__position_2 = null
			push_error ("Connection can only retrieve a Position node!")
	else:
		__position_2 = null
	__render_line ()

# - Sets the line for the connection -
func __render_line () -> void:
	# Don't draw a line when one or more positions are undefined
	if __position_1 == null or __position_2 == null:
		$Line.curve.clear_points ()
		return
	# We want two unique positions
	if __position_1 == __position_2:
		push_error ("One Position on both properties!")
		$Line.curve.clear_points ()
		return
	# Set the points for the 3D line
	$Line.curve.clear_points ()
	$Line.curve.add_point (__position_1.global_transform.origin)
	$Line.curve.add_point (__position_2.global_transform.origin)
