# Copyright 2022, Frederick Schenk

# --- Player Script ---
# Player figure and data pertaining to a player.

extends Spatial

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


# -- Functions --

# - Runs when scene is added to the scene tree
func _ready() -> void:
	# Check the value for the color
	if not color in COLOR_MATERIAL:
		color = PlayerColors.WHITE
	# Set the material for the mesh to the color
	var color_material : Material = COLOR_MATERIAL [color]
	mesh_node.set_surface_material (0, color_material)
