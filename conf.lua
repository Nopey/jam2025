love.conf = function(t)
   t.gammacorrect = true
   t.title, t.identity = "Deep Sea Diver", "Minimal"
   t.modules.joystick = false
   t.modules.physics = false
   -- NOTE: running the game at a resolution *above* what is specified here cuts off parts of the graphics, for some reason!
   -- hard-coding 1366x768 for now, since that's what the laptop the game is gonna be demoed on runs at.
   t.window.width = 1366
   t.window.height = 1025
   t.window.resizable = true
   -- t.window.fullscreen = true
   t.window.vsync = true
   t.version = "11.5"
end
