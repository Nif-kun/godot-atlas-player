# AtlasContainer <img align="center" alt="icon" width="40px" src="https://raw.githubusercontent.com/Nif-kun/godot-atlas-player/main/addons/AtlasPlayer/res/icon.svg" />
### An animation player using a TextureRect to display an AtlasTexture. An addon for the <a href="https://godotengine.org">Godot</a> engine.
 
* <a href="#description">Description</a></li>
* <a href="#installation">Installation</a></li>
* <a href="#usage">Usage</a></li>
* <a href="#signals">Signals</a></li>
* <a href="#functions">Functions</a></li>
* <a href="#properties">Properties</a></li>
* <a href="#issues">Issues</a></li>


## <a name="description">Description</a>
Somewhat similar to the AnimatedSprite node, AtlasPlayer is a way to animate an atlas or a sprite sheet. 
The difference in benefit comes from the adjustable size of AtlasPlayer. In other words, it can be used for UI purposes such as loading screen 
or even gifs! In truth, it all comes down to what your project is. If this addon fits your need, might as well try it out. 


## <a name="installation">Installation</a>
1. Download the latest version in <a href="https://github.com/Nif-kun/godot-atlas-player/releases">releases</a> or clone the repository.
2. Copy the contents of `addons/AtlasPlayer` into your `res://addons/AtlasPlayer` directory.
3. Enable `Dialogue Manager` in your project plugins.


## <a name="usage">Usage</a>
1. Create an AtlasPlayer in the current scene and modify the properties in the inspector.
2. Set an image for the `Atlas Texture`. Recommended to drag and drop the image directly in the inspector.
3. Based on the number of tiles, set the `Hframe` for width and `Vframe` for height. 
<br />Example: a character sprite with six tiles of movement, with a width of three (3) tiles and height of two (2).
<br />The `Hframe` in the scenario would be three (3) and the `Vframe` would be two (2).
4. Set the `Start Frame` and the `End Frame`. The starting and ending point of the animation.
5. Adjust the `Speed` of the player to best fit the animation.
6. Before moving to the next step, it is recommended to turn on the `Auto Start`. Otherwise, use the `start()` function of the node to play the animation.
7. Play the scene and see if the sprite plays properly.

**Note: the instructions can also be applied in code. See the script for more details such as the `start()` and `stop()` function.**

## <a name="signals">Signals</a>
Name           | Definition
-------------- | -------------
Started        | emitted once the animation starts.
Stopped        | emitted once the animation ends.

## <a name="functions">Functions</a>
Name                          | Definition
----------------------------- | -------------
start(check:bool=true)        | starts the animation. Takes a non-required argument that can be used to stop the animation from reseting frame position.
stop(check:bool=true)         | stops the animation. Takes a non-required argument that can be used to stop the animation from reseting frame position.

## <a name="properties">Properties</a>
Property         | Type             | Definition
---------------- | ---------------- | -------------
Atlas Texture    | Texture          | the image texture to be used for the animation. 
HFrame           | int              | the number of tiles in width.
VFrame           | int              | the number of tiles in height.
Start Frame      | int              | the starting tile/frame of the animation.
End Frame        | int              | the ending tile/frame of the animation.
Loop             | boolean          | a condition if the animation will loop or not.
Auto Start       | boolean          | a condition if the animation will start upon entering the SceneTree.


## <a name="issues">Issues</a>
* None as of current...

**Said issues may be fixed in the future updates. However, if you know a way to fix it, do open up an issue or a pull request. Your contribution would be greatly apprciated**

