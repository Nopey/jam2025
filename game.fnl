(local hero (require :lander))
(local enemy (require :enemy-spawner))
(local lume (require :lib.lume))
(local moonshine (require :lib.moonshine))
(local sti (require :lib.sti))
(local bump (require :lib.bump))

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

      :i-time 0

      ; table of sprites
      :sprites []

      :test nil ; player

      :effect nil

      ; bump collision detection world
      :world nil
      
      :test-map nil

      :puff-sfx nil
      
      :init (fn init [self]
            (set self.test (hero.make-player self 100 100))

            
            (set self.world (bump.newWorld 32))
            (set self.test-map (sti "assets/testmap.lua" ["bump"]))
            (self.test-map:bump_init self.world)
            (self.world:add self.test 100 100 32 32)


            
            (set self.g-canvas (love.graphics.newCanvas self.internal-w self.internal-h))

            (set self.puff-sfx [
	            (love.audio.newSource "assets/3pops/pop1.ogg" "static")
	            (love.audio.newSource "assets/3pops/pop2.ogg" "static")
	            (love.audio.newSource "assets/3pops/pop3.ogg" "static")
            ])

            (set self.effect (moonshine moonshine.effects.scanlines))
            (set self.effect (self.effect.chain moonshine.effects.desaturate))
            (set self.effect (self.effect.chain moonshine.effects.boxblur))
            (set self.effect (self.effect.chain moonshine.effects.glow))
            (set self.effect (self.effect.chain moonshine.effects.chromasep))
            (set self.effect (self.effect.chain moonshine.effects.crt))
     
            (set self.sprites.airsupply_tank (love.graphics.newImage "assets/airsupply_tank.png"))
            (set self.sprites.airsupply_air (love.graphics.newImage "assets/airsupply_air.png"))
            (set self.sprites.airsupply_alarm (love.graphics.newImage "assets/airsupply_alarm.png"))

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
    :update (fn update [self dt]
        (set self.i-time (+ self.i-time  (* 1.0 dt ) ))

        (self.test-map:update dt)

        (self.test:update dt)
        (self.world:move self.test self.test.x self.test.y)
        
        (each [k bullet (pairs self.test.bullets)]
              (bullet:move dt)
              (if (bullet:hit)
                  (do 
                    (table.remove self.test.bullets k)
                    ;(print "removing bullet!")
                  )))
      
    )
     :draw (fn draw [self]

      

      	
        ; set the canvas we're rendering to
        ; (self.g-canvas:clear)
        ; (love.graphics.setCanvas self.g-canvas)
        (love.graphics.setCanvas {1 self.g-canvas :stencil true})
        (love.graphics.clear)
        (love.graphics.setStencilTest)
        ; (love.graphics.setBlendMode "alpha")
      

      	; draw the map
      	(self.test-map:draw)
        (love.graphics.setCanvas {1 self.g-canvas :stencil true})

        ; (love.graphics.setCanvas self.g-canvas)
        
        ; (love.graphics.setShader self.crt-shader)

        ; send the shader the canvas
        ; (self.crt-shader:send "SCREEN_TEXTURE" self.g-canvas)
        ; (self.crt-shader:send "iTime" self.i-time)

        ; (love.graphics.print   (.. "velocity-x: " self.test.velocity.x) 0 0)
        ; (love.graphics.print   (.. "velocity-y: " self.test.velocity.y) 0 25)
        ; (love.graphics.print   (.. "bullets: " (lume.count self.test.bullets)) 0 50)
        ; (love.graphics.print   (.. "i-time: " self.i-time) 0 75)
        ; (love.graphics.print   (.. "rotation: " self.test.rotation) 0 100)
        
        (each [k bullet (pairs self.test.bullets)]
              (bullet:draw))
        ; (love.graphics.print )
      	; (love.graphics.print "Hello from Fennel!" player.x player.y))
      	; (love.graphics.draw player.sprite player.x player.y))

      	
      	


        ; (self.effect
      	(self.test:draw)
        ; )

        ; draw airsupply ui
        (local supply-x 280)
        (local supply-y 10)
        (local supply-w 32)
        (local supply-h 16)
        (local airsupply-amt (/ self.test.airsupply self.test.airsupply-max))
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
                  (and (< self.test.airsupply self.test.airsupply-alarmthreshold) (< (% self.i-time 0.8) 0.5))
            )
            (love.graphics.draw self.sprites.airsupply_alarm supply-x supply-y)
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

            (set self.effect.scanlines.phase self.i-time)
            (set self.effect.scanlines.width (* scale 0.75))
            ; (set self.effect.scanlines.thickness (* scale 0.3))
            ; (set self.effect.scanlines.phase 1)
            (set self.effect.chromasep.radius (* scale 1))
            (set self.effect.boxblur.radius (* scale 0.3))

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
                  (/ (- (love.mouse.getX) screen-x) scale)
                  (/ (- (love.mouse.getY) screen-y) scale)
            ]
      )

      ; each HUMP compatible gamestate will need to implement this for hot reloading
      :reload (fn reload [self]
                  (lume.hotswap :game)
                  (self.init self))

      :keypressed (fn keypressed [self key scancode isrepeat]
                  (self.test:keypressed key scancode isrepeat))
      :keyreleased (fn keyreleased [self key scancode]
                  (self.test:keyreleased key scancode))

      :mousepressed (fn mousepressed [self x y button istouch]
                  (self.test:mousepressed x y button istouch))
      :mousereleased (fn mousereleased [self x y button istouch]
                  (self.test:mousepressed x y button istouch))

     }


