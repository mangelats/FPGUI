FPGUI
=====
What's this?
------
This is a library for ActionScript 3 and [FlashPunk] that allows to make a GUI for games easily.

It is in working process (specially the skin part) and i'm testing (if you find a bug, let me know).

Features
------
### Call directly the component
You can call components directly.

``` actionscript
[Embed(source = "normal_button.png")]
private const NORMAL:Class;
[Embed(source = "over_button.png")]
private const OVER:Class;
[Embed(source = "pressed_button.png")]
private const PRESSED:Class;

//Creating the button.
var button:Button = new Button(100, 150, NORMAL, OVER, PRESSED, "Click me!");

//Adding the button to the world.
add(button);
```

### Create or inport an skin

You can create an skin and make sure that every component follows the same rules.
``` actionscript
//embed the skin that have the information encoded
[Embed(source = "skin_name.png")]
private const SKIN:Class;

//create the skin and add it to the skin container
var skin:Skin = new Skin(SKIN, true);

//creates a 150x40 button in the position (100, 100)
var button:Button = skin.getButton(100, 100, 150, 40, "Click me!");
```

### Easy to handle events
You only have to set the function you want to the especific public variable.

``` actionscript
//Function that you want to be called
public function click():void
{
	trace("You've clicked the button!");
}

button.onClick = click;
```

Upcoming features
------
  - Make all the fucntions to allow skins to create components.
  - An skin editor.
  - Create a wiki.
  - More components (like a progress var).


[FlashPunk]:http://useflashpunk.net