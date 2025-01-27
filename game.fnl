(local hero (require :lander))
(local enemy (require :enemy-spawner))
(local lume (require :lib.lume))
(local moonshine (require :lib.moonshine))
(local sti (require :lib.sti))
(local bump (require :lib.bump))

(local airsupplyline-quads {})
(local airsupplyline-fps -3) ; oops i made the airsupply animate backwards
(let [frame-w 32 frame-h 16 frame-count 4] (for [f 1 frame-count]
    (table.insert airsupplyline-quads
        (love.graphics.newQuad 0 (* (- f 1) frame-h) frame-w frame-h frame-w (* frame-h frame-count))
    )
))

{

      
      ; load the crt shader
      ; :crt-shader (love.graphics.newShader "crt.glsl")
;       :crt-shader (love.graphics.newShader "vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
;   vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
;   float average = (pixel.r+pixel.b+pixel.g)/3.0;
;   float factor = texture_coords.x;
;   pixel.r = pixel.r + (average-pixel.r) * factor;
;   pixel.g = pixel.g + (average-pixel.g) * factor;
;   pixel.b = pixel.b + (average-pixel.b) * factor;
;   pixel.a = 0.5;

;   return pixel;
; ; }")
;       :crt-shader (love.graphics.newShader "vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
;   vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
;   number average = (pixel.r+pixel.b+pixel.g)/3.0;
;   number factor = texture_coords.x;
;   pixel.r = pixel.r + (average-pixel.r) * factor;
;   pixel.g = pixel.g + (average-pixel.g) * factor;
;   pixel.b = pixel.b + (average-pixel.b) * factor;
;   return pixel;
; }")
      ; :g-canvas (love.graphics.newCanvas 320 180)
      :g-canvas nil ; canvas for offscreen rendering (fixed resolution)
      :internal-w 320
      :internal-h 240

      ; amount of hitstun remaining
      :hitstun 0
      ; used to change the 'current time' without running into floating point precision issues
      :gametime-offset 0

      ; table of sprites
      :sprites []

      :test nil ; player

      :effect nil

      ; bump collision detection world
      :world nil
      :draw_wireframe false
      
      :test-map nil

      :map-x 0
      :map-y 0
      :map-scroll-speed 0.05
      :map-scroll-enabled false

      :bg-music (love.audio.newSource "assets/music/bg-music.mp3" "stream")

      :puff-sfx nil
      
      :init (fn init [self]
            ; (set self.test (hero.make-player self 100 100))
            (set self.gametime-offset 0)
            
            (set self.world (bump.newWorld 32))
            (set self.test-map (sti "assets/maps/map1.lua" ["bump"]))
            (self.test-map:bump_init self.world)

            (print "items in world: " (self.world:getItems))

            ; fish out spawn locations from the Spawn Locations layer, then delete it from the bump world (useless)

            ; (each [key value (pairs self.test-map.layers)]
            ;       (print "key: " key " value: " value))


            (each [ key value (pairs self.test-map.layers.spawn-location) ]
                  (print "key: " key " value: " value))


            ; (set self.map-x self.test-map.tilewidth)
            (set self.map-y (* (- self.test-map.height 15) self.test-map.tileheight))


            
            (each [ _ object (pairs self.test-map.layers.spawn-location.objects) ]
                        (print object)
                        (when (= object.name "Player")
                              (set self.test (hero.make-player self object.x object.y))
                              (self.world:add self.test (self.test:get-collision-x) 
                                              (self.test:get-collision-y) 
                                              self.test.width self.test.height)
                        )
                       )
                  

            ; (. self.world.layers "Spawn Locations")
            
            
            (set self.g-canvas (love.graphics.newCanvas self.internal-w self.internal-h))

            (set self.puff-sfx [
	            (love.audio.newSource "assets/3pops/pop1.ogg" "static")
	            (love.audio.newSource "assets/3pops/pop2.ogg" "static")
	            (love.audio.newSource "assets/3pops/pop3.ogg" "static")
            ])

            (love.graphics.setDefaultFilter :linear)
            (set self.effect (moonshine moonshine.effects.scanlines))
            (set self.effect (self.effect.chain moonshine.effects.desaturate))
            (set self.effect (self.effect.chain moonshine.effects.boxblur))
            (set self.effect (self.effect.chain moonshine.effects.glow))
            (set self.effect (self.effect.chain moonshine.effects.chromasep))
            (set self.effect (self.effect.chain moonshine.effects.crt))
            (love.graphics.setDefaultFilter :nearest)
     
            (set self.sprites.airsupply_tank (love.graphics.newImage "assets/airsupply_tank.png"))
            (set self.sprites.airsupply_air (love.graphics.newImage "assets/airsupply_air.png"))
            (set self.sprites.airsupply_alarm (love.graphics.newImage "assets/airsupply_alarm.png"))
            (set self.sprites.airsupply_line (love.graphics.newImage "assets/airsupply_line.png"))
            (set self.sprites.youdied (love.graphics.newImage "assets/youdied.png"))
            (set self.sprites.dumboverlay (love.graphics.newImage "assets/dumboverlay.png"))

              (self.test:load)
              ; ; testing wave generator
              (var get-next-wave 
                  (enemy.wave-generator [
                                        	["one" "two" "three"]
                                        	["a" "b" "c"]
                                        ]))
              (each [key value (pairs (get-next-wave))] 
                    (print value)
              	)
              (each [key value (pairs (get-next-wave))] 
                    (print value)
              	)


    )     
      :update (fn update [self real-dt]
        (var dt real-dt)

        ; handle hitstun, freeze dt during hitstun.
        (set self.hitstun (math.max 0 (- self.hitstun dt)))
        (when (> self.hitstun 0)
            (set self.gametime-offset (- self.gametime-offset dt))
            (set dt 0)
        )

        (self.test-map:update dt)

        (self.test:update dt)

      (when (not (= nil self.shake))
            (set self.shake (- self.shake real-dt))
            (when (< 0 self.shake-fade)
                  (local decay (math.exp (- (* dt self.shake-fade))))
                  ; (print "decay" decay "magn " self.shake-magnitude)
                  (set self.shake-magnitude (* self.shake-magnitude decay))
            )
            (when (> 0 self.shake)
                  (set self.shake nil)
            )
      )
        
        (each [k bullet (pairs self.test.bullets)]
              (bullet:move dt)
              (if (bullet:hit)
                  (do 
                    (table.remove self.test.bullets k)
                    ;(print "removing bullet!")
                  )))


      ; only scroll if enabled, good for debug
      (if self.map-scroll-enabled
            (set self.map-y (- self.map-y self.map-scroll-speed )))
      ; Debug scroll buttons
      (if (love.keyboard.isDown "pageup")
         (set self.map-y (- self.map-y (* 20 self.map-scroll-speed ))))
      (if (love.keyboard.isDown "pagedown")
         (set self.map-y (+ self.map-y (* 20 self.map-scroll-speed ))))
    )
     :draw (fn draw [self]
     
      (var camera-x self.map-x)
      (var camera-y self.map-y)

      (when (not (= nil self.shake))
            (set camera-x (+ camera-x (* self.shake-magnitude (lume.random -1 1))))
            (set camera-y (+ camera-y (* self.shake-magnitude (lume.random -1 1))))
      )

      ; (set self.map-y (- self.map-y self.map-scroll-speed ) )
        ; set the canvas we're rendering to
        ; (self.g-canvas:clear)
        ; (love.graphics.setCanvas self.g-canvas)
        (love.graphics.setCanvas {1 self.g-canvas :stencil true})
        (love.graphics.clear)
        (love.graphics.setStencilTest)
        ; (love.graphics.setBlendMode "alpha")
      

        ; draw the map
        (self.test-map:draw  (- camera-x) (- camera-y))
        (love.graphics.setCanvas {1 self.g-canvas :stencil true})


        (love.graphics.push)
        (love.graphics.translate (- camera-x) (- camera-y))

        ; (love.graphics.setCanvas self.g-canvas)
        
        ; (love.graphics.setShader self.crt-shader)

        ; send the shader the canvas
        ; (self.crt-shader:send "SCREEN_TEXTURE" self.g-canvas)
        ; (self.crt-shader:send "iTime" (self:gametime))

        ; (love.graphics.print   (.. "velocity-x: " self.test.velocity.x) 0 0)
        ; (love.graphics.print   (.. "velocity-y: " self.test.velocity.y) 0 25)
        ; (love.graphics.print   (.. "bullets: " (lume.count self.test.bullets)) 0 50)
        ; (love.graphics.print   (.. "i-time: " (self:gametime)) 0 75)
        ; (love.graphics.print   (.. "rotation: " self.test.rotation) 0 100)
        
        (each [k bullet (pairs self.test.bullets)]
              (bullet:draw))
        ; (love.graphics.print )
      	; (love.graphics.print "Hello from Fennel!" player.x player.y))
      	; (love.graphics.draw player.sprite player.x player.y))

            (self.test:draw)

            (when self.draw_wireframe
                  (self.test-map:bump_draw 0 0 1 1)
            )

        (love.graphics.pop)

        ; draw airsupply ui
        (local supply-x 270)
        (local supply-y 10)
        (local supply-w 32)
        (local supply-h 16)
        (local airsupply-amt (/ self.test.airsupply self.test.airsupply-max))

        ; draw airsupply line first.
        (local airsupplyline-frame (if
            (< airsupply-amt 0) 1 ; out of gas!
            (+ 2 (% (math.floor (* self.test.airsupply airsupplyline-fps)) 3))
        ))
        (love.graphics.draw self.sprites.airsupply_line (. airsupplyline-quads airsupplyline-frame)
            (+ supply-x 29)
            (+ supply-y 4)
      )

        (love.graphics.draw self.sprites.airsupply_tank supply-x supply-y)
        (love.graphics.stencil (fn draw-airsupply-stencil []
            (love.graphics.rectangle "fill" (+ supply-x (* supply-w (- 1 airsupply-amt))) supply-y supply-w supply-h)
        ))
        (love.graphics.setStencilTest "equal" 1)
        (love.graphics.draw self.sprites.airsupply_air supply-x supply-y)
        (love.graphics.setStencilTest)
        (when (or
                  ; completely out, draw alarm on all frames.
                  (< self.test.airsupply 0)
                  ; blink alarm when we're low
                  (and (< self.test.airsupply self.test.airsupply-alarmthreshold) (< (% (self:gametime) 0.8) 0.5))
            )
            (love.graphics.draw self.sprites.airsupply_alarm supply-x supply-y)
        )

      (love.graphics.draw self.sprites.dumboverlay 0 0) ; dumb overlay to make top and bottom of screen look more dangeruos1!!

        ; draw youdied overlay
        (when (self.test:is-dead)
            (love.graphics.draw self.sprites.youdied 0 0)
        )

        (love.graphics.setCanvas)
        (do
            (local scale (math.min
                  (/ (love.graphics.getWidth) self.internal-w)
                  (/ (love.graphics.getHeight) self.internal-h)
            ))
            (local screen-x (/ (- (love.graphics.getWidth) (* self.internal-w scale)) 2))
            (local screen-y (/ (- (love.graphics.getHeight) (* self.internal-h scale)) 2))

            ; TODO: Set desaturate strength based on how much damage the player's CRT has taken.
            (set self.effect.desaturate.strength 0.05)
            ; (set self.effect.desaturate.strength 0.2)

            (set self.effect.scanlines.phase (* 1.5 (love.timer.getTime)))
            (set self.effect.scanlines.width (* scale 0.75))
            ; (set self.effect.scanlines.thickness (* scale 0.3))
            (set self.effect.chromasep.radius (* scale 1))
            (set self.effect.boxblur.radius (* scale 0.3))

            ; (love.graphics.draw self.g-canvas 0 0) ; if you want to see the raw framebuffer
            (self.effect
                  #(love.graphics.draw self.g-canvas screen-x screen-y 0 scale)
            )
        )

    	)

      :getmouse (fn getmouse [self]
            (local scale (math.min
                  (/ (love.graphics.getWidth) self.internal-w)
                  (/ (love.graphics.getHeight) self.internal-h)
            ))
            (local screen-x (/ (- (love.graphics.getWidth) (* self.internal-w scale)) 2))
            (local screen-y (/ (- (love.graphics.getHeight) (* self.internal-h scale)) 2))
            [
                  (+ (/ (- (love.mouse.getX) screen-x) scale) self.map-x)
                  (+ (/ (- (love.mouse.getY) screen-y) scale) self.map-y)
            ]
      )

      :apply-hitstun (fn apply-hitstun [self amount maximum-hitstun]
            (local maximum-hitstun (or maximum-hitstun 0.3))
            (local incremental-hitstun (or amount 0.1))
            (when (> maximum-hitstun self.hitstun) ; don't apply hitstun if someone else has applied more
                  (set self.hitstun (math.min maximum-hitstun (+ incremental-hitstun self.hitstun)))
            )
      )

      ; duration: how long to apply screenshake
      ; magnitude: how much screenshake
      ; fade: higher number = decays faster. 0 = no decay
      :apply-screenshake (fn apply-screenshake [self duration magnitude fade]
            (when (or (= self.shake nil) (> magnitude self.shake-magnitude))
                  (set self.shake duration)
                  (set self.shake-magnitude magnitude)
                  (set self.shake-fade fade)
                  ; (print "applied " self.shake self.shake-magnitude self.shake-fade)
            )
      )

      :gametime (fn gametime [self]
            (+ self.gametime-offset (love.timer.getTime))
      )

      ; each HUMP compatible gamestate will need to implement this for hot reloading
      :reload (fn reload [self]
                  (lume.hotswap :game)
                  (self:init))

      :keypressed (fn keypressed [self key scancode isrepeat]
                  (when (= "f3" key)
                        (set self.map-scroll-enabled (not self.map-scroll-enabled)))
                  (self.test:keypressed key scancode isrepeat))

      
      :keyreleased (fn keyreleased [self key scancode]
                  (self.test:keyreleased key scancode)
                  (when (= "f1" key) (set self.draw_wireframe (not self.draw_wireframe)))
      )

      :mousepressed (fn mousepressed [self x y button istouch]
                  (self.test:mousepressed x y button istouch))
      :mousereleased (fn mousereleased [self x y button istouch]
                  (self.test:mousepressed x y button istouch))

     }


