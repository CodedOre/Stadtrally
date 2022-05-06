# Movement on the Board

This document aims to describe the systems that manage the movement of the player on the game board and ensure a player can only move inside of the rules of the game.

## Overview of components

The main components of this system are the `RallyGame` scene, to which most of the scripts for controlling it are connected to, as well as the data structures `Player`, `Position` and `Connection`.

### `RallyGame`

The `RallyGame` scene manages one game session and has the scripts connected that recieve input, manage player movement and their position and the turns and moves. This functionality is split between a few scripts, which are connected to nodes in this main scene:

- `RallyGame` itself manages the turns and which player can currently play. It also serves as the main script, providing relevant information to the other scripts.
- `BoardManager` handles the position of the players, and checks after a movement request if it is correct.
- `Dice` is responsible for providing the random number used to determine how many moves a player can have. It will later also display a dice roll to the player as visualization.
- `GameInput` is the node that takes the input from the player, determines the action to be taken and gives it via signals to the sub-nodes for processing.

#### Displaying a Game Board

The `RallyGame` scene itself does not have a game board. Instead, it can be provided with another scene which will be used as the game board. As of now this is set to the `DemoBoard` scene found in the demo folder. When a game is started this scene is loaded and added as a child to the scene tree, while relevant nodes such as players and positions are automatically detected and managed using Godot's group feature.

### `Player`

The `Player` node primarily serves a data structure and as the model for the player figure on the game board, lacking much code on it's own. While the data stored as of now only is the players color, it will gain additional information about points when the scripts using this will be implemented.

`Player` extends the `KinematicBody` node, which is a physics body which can be moved by code, but is not affected by physics. Making it a physics body was necessary so that `GameInput` could detect it with an raycast, but since it is entirely moved by scripts it does not need to consider physics.

### `Position`

The `Position` node serves as points on the game board where a player can move to. Like `Player` it only stores data, in this case it stores an two-dimensional array of 3D vectors which are used to position the players on a position depending on how many are standing there. Additionally, it contains an frame which is displayed contextually to note the player if he can move his figure to this position. For this, it also has a `feedback` state variable, which determines the visibility and color of the frame.

### `Connection`

In order to allow a player to move from one position to another, these positions need to be connected using the `Connection` node. This node also contains a 3D line, which is automatically placed to show the connection of the two positions, giving immediate feedback in the editor when creating a game board.

## The process of moving a player

### Getting the Input

When an left click on the board is detected, it is caught by the `GameInput` script. It then determines one of two actions that allow to move an player. In order to do this, it at first only notes that a click happened and waits for the next action. If the button is released, it notes it as a click to select an player of position. If a mouse motion is detected while the mouse stays pressed, it interprets this action as an drag of an player.

In both cases the next action is to determine where the mouse click went. To do this `GameInput` creates an ray cast to find the object beneath the mouse cursor. If it is not an `Player` or `Position`, the input is ignored, otherwise it takes the detected object and refers it to the sub-nodes `PlayerDrag` or `PlayerClick`, which translate the input actions into movement requests.

When both classes are getting notified about a new player being selected or dragged, at first they check if the player is the currently active one. If not, the input is discarded. If it is the current one though they next notify `BoardManager` to display where the player can be moved, which is done by displaying the frame of the positions.

While the user drags his figure, `PlayerDrag` get's the position the mouse is pointing at from `GameInput` and updates the position of the player figure accordingly.

When the dragged player is dropped, or in case of `PlayerClick` an position to move to is selected, `BoardManager` is notified to clear the position hints and check if the move can be done.

### Checking the validity of a move

During a game session, `BoardManager` holds an internal representation of the game board using a graph data structure, using Godot's `AStar` implementation.

When it is now notified about an move to check, it takes the start position of the player and determines all positions the player could move to from there. This is done by a custom function which get's all valid positions connecting to the starting position and repeats this for the amount of moves the player is allowed to have. It then returns an array containing these position with the number of moves necessary to move there.

When checking the movement request, it is now checked if the target position is referenced in the set of valid positions. If not, the move cannot be done by the player, which figure is then moved back to the start position. If it is possible, the amount of moves are subtracted from the allowed moves for the player and the figure moved to the new assigned origin on the position.

It is possible that the player has only made a small step, having moves left over. In order to prevent that he moves backwards in the same turn, violating the rules of the game, `BoardManager` get's the path the player has taken using the graph path function. The positions on this paths are then marked and excluded when looking for valid moves in other iterations in the same turn, which is also the reason we needed the custom function before.

When all moves are taken, `RallyGame` selects the next player in line and the excluded paths are reset.
