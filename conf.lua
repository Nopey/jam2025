love.conf = function(t)
   t.gammacorrect = true
   t.title, t.identity = "AWA", "Minimal"
   t.modules.joystick = false
   t.modules.physics = false
   -- NOTE: running the game at a resolution *above* what is specified here cuts off parts of the graphics, for some reason!
   t.window.width = 1366
   t.window.height = 1024
   t.window.resizable = true
   t.window.vsync = true
   t.version = "11.5"

   require("os")
   if os.getenv("USER") == "magnus" then
      -- config for magnus's laptop
      t.window.fullscreen = true
      t.window.width = 1366
      t.window.height = 768
   end
end
