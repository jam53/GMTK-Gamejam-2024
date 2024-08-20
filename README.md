# Honey Horizon
Honey Horizon was made for the [GMTK 2024 game jam](https://itch.io/jam/gmtk-2024) by a team of three people, around the theme “Built to Scale.”

![](./assets/sprites/HoneyHorizonGameplay.jpg)

## Keybinds
- **WASD/ZQSD**: Camera movement
- **E**: Lock/Unlock the attacker bees somewhere on the map
- **M**: Toggle whether or not the camera can also be moved by dragging the mouse outside the boundaries of the screen.
- **Click** on an item in the shop at the bottom of the screen, then click somewhere on the map to place the selected item. This can be canceled by pressing **ESC**.

## Goal of the game
Try to survive as long as possible.

## Documentation
### Prerequisites
- [Godot](https://godotengine.org/download/)
  > Since this project doesn't use C#, the standard Godot Engine download should suffice. However, the Godot Engine - .NET build should also still work.

### Cloning Honey Horizon
- Cloning using *Git*:
    ```
    git clone https://github.com/jam53/GMTK-Gamejam-2024.git
    ```
- Cloning using *GitHub Desktop*:
    - Open GitHub Desktop > file > Clone repository > URL > enter the following url: https://github.com/jam53/GMTK-Gamejam-2024.git and press *Clone*.

### Building Honey Horizon
To export a standalone binary for Honey Horizon:

1. Navigate to `Project > Export...`.
2. Select the **Windows Desktop** export preset.
3. Click on **Export Project...**.
4. Choose the path where you want to save the exported project.
5. Untick the `Export With Debug` option.

> While exporting the project, you may run into the following warning, which you can ignore:
> ```
> Resources Modification: Could not start rcedit executable. 
> Configure rcedit path in the Editor Settings (Export > Windows > rcedit),
> or disable 'Application > Modify Resources' in the export preset.
> ```