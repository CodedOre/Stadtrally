# Movement on the Board

This document aims to describe the systems that manage the movement of the player on the game board and ensure a player can only move inside of the rules of the game.

## Overview of components

The main components of this system are the `RallyGame` scene, to which most of the scripts for controlling it are connected to, as well as the data structures `Player`, `Position` and `Connection`.

### [`RallyGame`](https://github.com/CodedOre/Stadtrally/blob/main/scenes/game/RallyGame.tscn)

The `RallyGame` scene manages one game session and has the scripts connected that recieve input, manage player movement and their position and the turns and moves. This functionality is split between a few scripts, which are connected to nodes in this main scene:

- `RallyGame` itself manages the turns and which player can currently play. It also serves as the main script, providing relevant information to the other scripts.
- `BoardManager` handles the position of the players, and checks after a movement request if it is correct.
- `Dice` is responsible for providing the random number used to determine how many moves a player can have. It will later also display a dice roll to the player as visualization.
- `GameInput` is the node that takes the input from the player, determines the action to be taken and gives it via signals to the sub-nodes for processing.

#### Displaying a Game Board

The `RallyGame` scene itself does not have a game board. Instead, it can be provided with another scene which will be used as the game board. As of now this is set to the [`DemoBoard`](https://github.com/CodedOre/Stadtrally/blob/main/demo/DemoBoard.tscn) scene found in the demo folder. When a game is started this scene is loaded and added as a child to the scene tree, while relevant nodes such as players and positions are automatically detected and managed using Godot's group feature.

### [`Player`](https://github.com/CodedOre/Stadtrally/blob/main/scenes/game/Player.tscn)

The `Player` node primarily serves a data structure and as the model for the player figure on the game board, lacking much code on it's own. While the data stored as of now only is the players color, it will gain additional information about points when the scripts using this will be implemented.

`Player` extends the `KinematicBody` node, which is a physics body which can be moved by code, but is not affected by physics. Making it a physics body was necessary so that `GameInput` could detect it with an raycast, but since it is entirely moved by scripts it does not need to consider physics.

### [`Position`](https://github.com/CodedOre/Stadtrally/blob/main/scenes/board/Position.tscn)

The `Position` node serves as points on the game board where a player can move to. Like `Player` it only stores data, in this case it stores an two-dimensional array of 3D vectors which are used to position the players on a position depending on how many are standing there. Additionally, it contains an frame which is displayed contextually to note the player if he can move his figure to this position. For this, it also has a `feedback` state variable, which determines the visibility and color of the frame.

### [`Connection`](https://github.com/CodedOre/Stadtrally/blob/main/scenes/board/Connection.tscn)

In order to allow a player to move from one position to another, these positions need to be connected using the `Connection` node. This node also contains a 3D line, which is automatically placed to show the connection of the two positions, giving immediate feedback in the editor when creating a game board.
