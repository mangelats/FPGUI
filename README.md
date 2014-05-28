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

var button:Button = new Button(100, 150, NORMAL, OVER, PRESSED, "Click me!);

add(button);
```

[FlashPunk]:http://useflashpunk.net