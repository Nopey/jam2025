(local hero (require :lander))
(local enemy (require :enemy-spawner))
(local lume (require :lib.lume))
(local moonshine (require :lib.moonshine))

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
      :g-canvas (love.graphics.newCanvas)

      :i-time 0


      :test (hero.make-player 100 100)

      :effect (moonshine moonshine.effects.scanlines) 

      :init (fn init [self]
            ; (set self.effect (self.effect.chain moonshine.effects.desaturate))
            (set self.effect (self.effect.chain moonshine.effects.boxblur))
            (set self.effect (self.effect.chain moonshine.effects.glow))
            (set self.effect (self.effect.chain moonshine.effects.chromasep))
            (set self.effect (self.effect.chain moonshine.effects.crt))
     
            (set self.effect.scanlines.width 1.5)
            (set self.effect.chromasep.radius 2)
            (set self.effect.boxblur.radius 0.3)

            ; (set self.effect.scanlines.thickness 5)
            ; (set self.effect.scanlines.phase 1)

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
        (set self.i-time (+ self.i-time  (* 1.5 dt ) ))
        (set self.effect.scanlines.phase self.i-time)
        (self.test:update dt)
        (each [k bullet (pairs self.test.bullets)]
              (bullet:move dt)
              (if (bullet:hit)
                  (do 
                    (table.remove self.test.bullets k)
                    (print "removing bullet!")
                  )))
    )
     :draw (fn draw [self]


      
        ; set the canvas we're rendering to
        ; (self.g-canvas:clear)
        (love.graphics.setCanvas self.g-canvas)
        (love.graphics.clear)
        ; (love.graphics.setBlendMode "alpha")
      
        ; (love.graphics.setShader self.crt-shader)

        ; send the shader the canvas
        ; (self.crt-shader:send "SCREEN_TEXTURE" self.g-canvas)
        ; (self.crt-shader:send "iTime" self.i-time)

        (love.graphics.print   (.. "velocity-x: " self.test.velocity.x) 0 0)
        (love.graphics.print   (.. "velocity-y: " self.test.velocity.y) 0 25)
        (love.graphics.print   (.. "bullets: " (lume.count self.test.bullets)) 0 50)
        (love.graphics.print   (.. "i-time: " self.i-time) 0 75)
        (love.graphics.print   (.. "rotation: " self.test.rotation) 0 100)


        
        (each [k bullet (pairs self.test.bullets)]
              (bullet:draw))
        ; (love.graphics.print )
      	; (love.graphics.print "Hello from Fennel!" player.x player.y))
      	; (love.graphics.draw player.sprite player.x player.y))

      	
      	; (self.effect 
      	(self.test:draw)
      ; )
      	(love.graphics.setCanvas)

      	(self.effect 
            	#(love.graphics.draw self.g-canvas)
        )
        
        ; (love.graphics.setShader)
      	; (love.graphics.draw self.g-canvas 200 200 0.25)
    	)


      ; each HUMP compatible gamestate will need to implement this for hot reloading
      :reload (fn reload [self]
                  (lume.hotswap :game)
                  (self.init self))

  
     }


