FPGUI
=====
What's this?
------
This is an library for ActionScript 3 and [FlashPunk] that allows to make a GUI for games easily.

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
(Still in progress)
You can create an skin and make sure that every component follows the same rules.

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

### Different ways to add a graphic
You can use a FlashPunk graphic (any kind), but you can also use an embed class (that will be transformed into an stamp) or make a function that returns a graphic depending on the variables that you want.

Upcoming features
------
  - Make all the fucntions to allow skins to create components.
  - An skin editor.
  - Create a wiki.
  - More components (like a progress var).


[FlashPunk]:http://useflashpunk.net