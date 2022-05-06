# Stadtrally

This contains the files for a project create in the Game Engineering course in the Hochschule Mannheim.

## Concept

The concept for the game is a rally through a city. Players race to various quiz points to get points for getting a right answer on a question on the history of the city, with the player to first have a set amount of numbers being allowed to move to the finish and win the game.

Movement on the board is non-linear, with player being allowed to approach the questions in what order they seem fit, but limited to a amount of moves determined by an dice roll.

## About the project

This project was developed in the **Godot Engine**, using the **version 3.4**.

Unless it is noted otherwise in the file [`Credits.md`](Credits.md), code and assets in this repository were created by Frederick Schenk.

### Running the project

In order to run this project proceed as follows:

- Clone this repository to your system.
- Open the project.godot file in the Godot Engine Editor.
- To run it simply press F5 to launch the main scene.

### Project structure

The project is structured in the following folders:

- `addons`: Addons extending the Engine with features needed by the project.
- `demo`: Contains files created to test out game mechanics, until proper content is added.
- `raw-assets`: The source files for various resources, which is not included in the Engine.
- `resources`: Resources like models, textures or shaders used by the Engine.
- `scenes`: Objects and Nodes used in the game.
- `scripts`: Script files in GDScript used to control the game.
