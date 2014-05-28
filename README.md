FPGUI
=====

What's this?
------
This is an library for ActionScript 3 and [FlashPunk] that allows to make an UI easily.

Two ways to create a UI
------
You can directly call the diferent components like Buttons or a Textfield, or you can make and import skins that allows you to make sure every component is as you wanted.

### Call directly the component
``` actionscript
[Embed(source = "normal_button.png")]
private const NORMAL:Class;
[Embed(source = "over_button.png")]
private const OVER:Class;
[Embed(source = "pressed_button.png")]
private const PRESSED:Class;

var button:Button = new Button(100, 150, NORMAL, OVER, PRESSED, "Click me!");

add(button);
```

### Easy to handle events
``` actionscript
button.onClick = click;

private function click():void
{
	trace("You clicked the button!");
}
```

### You can use different things as the graphic
You can use a FlashPunk graphic, an embed class (will be converted into an stamp) or a function that returns a FlashPunk graphic.

Upcoming features
------
  - An skin editor
  - More components (like a progress var);


[FlashPunk]:http://useflashpunk.net