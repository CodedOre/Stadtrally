# Copyright 2022, Frederick Schenk

# --- Player Script ---
# Player figure and data pertaining to a player.

extends KinematicBody

# -- Enums --

# - Possible colors for a player -
enum PlayerColors {
	WHITE,
	BLUE,
	GREEN,
	RED,
	YELLOW,
	PURPLE
}


# -- Constants --

# - The material connected to a color enum -
const COLOR_MATERIAL : Dictionary = {
	PlayerColors.WHITE: preload ("res://resources/material/game/Player/White.tres"),
	PlayerColors.BLUE: preload ("res://resources/material/game/Player/Blue.tres"),
	PlayerColors.GREEN: preload ("res://resources/material/game/Player/Green.tres"),
	PlayerColors.RED: preload ("res://resources/material/game/Player/Red.tres"),
	PlayerColors.YELLOW: preload ("res://resources/material/game/Player/Yellow.tres"),
	PlayerColors.PURPLE: preload ("res://resources/material/game/Player/Purple.tres")
}


# -- Nodes --

# - The MeshInstance for the player -
onready var mesh_node : MeshInstance = $Mesh


# -- Properties --

# - The color used by the player -
export (PlayerColors) var color


# -- Variables --

# - A Tween to animate the movement of the player to a new position -
var move_tween : Tween


# -- Functions --

# - Runs when scene is added to the scene tree
func _ready() -> void:
	# Check the value for the color
	if not color in COLOR_MATERIAL:
		color = PlayerColors.WHITE
	# Set the material for the mesh to the color
	var color_material : Material = COLOR_MATERIAL [color]
	mesh_node.set_surface_material (0, color_material)
	# Create the movement tween
	move_tween = Tween.new ()
	add_child (move_tween)

# - Set a target position the player should be moved to -
func set_target_position (target : Vector3, animated : bool = true, speed : float = 0.25) -> void:
	# Check if it should be animated
	if not animated:
		# Else just update position
		global_transform.origin = target
		return
	print ("We speed at " + str (speed))
	# Create the current and target transforms
	var current_transform : Transform = global_transform
	var target_transform : Transform = Transform (current_transform.basis, target)
	# Start the tween and set the transform interpolation
	# warning-ignore:return_value_discarded
	move_tween.interpolate_property (self, "global_transform", current_transform, target_transform, speed, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	# warning-ignore:return_value_discarded
	move_tween.start ()
	# Wait until the interpolation has completed
	yield (move_tween, "tween_completed")
