
(local lume (require :lib.lume))
(local bullet (require :bullet))
(local angle (require :angle))
; (var bullets [])


(var input [])

(fn make-player [game start-x start-y]  
    (var tb [])
    {
		:game game
     	:x start-x
     	:y start-y
     	:speed 100

		:use-mouse-controls false

     	:direction 1

			:velocity {:x 0 :y 0}
			
      ; radians
			:rotation 0
			:rot-speed 1.5
			:drag-speed 10

			:airsupply 5
			:airsupply-max 8
			:airsupply-alarmthreshold 2

			:max-velocity 200

			; when did the player start charging?
			:charge_time nil
			:charge_max 1.4

			:sprite nil

			:animation {
				:frames 0
				:quad nil
			}

			:bullets tb
			
			:shoot (fn shoot [self dir]
			           (table.insert self.bullets (bullet.make self.x self.y self.rotation 500)))
			
     	:load (fn load [self]
     	          (set self.sprite
     	                 (love.graphics.newImage "assets/witch.png"))
     	          (set self.animation.frames 4)

     	          (set self.bullets [])
     	          (let [width (self.sprite:getWidth)
     	                height (self.sprite:getHeight)]
     	          	
			     	          (set self.animation.quad
			     	          	(love.graphics.newQuad 0 0 (/ width 4) height width height))))

     	 :keyreleased (fn keyreleased [self key]

		 	; release charge as bullet
			(when (and (= key "x") self.charge_time)
				(self:shoot self.direction)
				(set self.charge_time nil)
			)
		 )

		:mousepressed (fn mousepressed [self x y button istouch]
			(set self.use-mouse-controls true)
			;(print "AYO!! mousepressed." button)
		)
		:keypressed (fn keypressed [self key scancode isrepeat]
			(set self.use-mouse-controls false)
			;(print "AYO!! keypressed." key)

			; start charging
			(when (and (= key "x") (not self.charge_time)) (set self.charge_time (love.timer.getTime)))
		)

			:update (fn update [self dt]

			  (let [move {:x 0 :y 0}]

			  	; gravity
			  	; (set self.velocity.y (+ self.velocity.y (* dt 350)))

			  	    

			    (if 
					(love.keyboard.isDown "right") (do
						(set self.rotation (angle.normalize (+ self.rotation (* dt self.rot-speed))))
					)
					(love.keyboard.isDown "left") (do
						(set self.rotation (angle.normalize (- self.rotation (* dt self.rot-speed))))
					)
					self.use-mouse-controls (do
						(local [mousex mousey] (self.game:getmouse))
						(local target_angle (lume.angle self.x self.y mousex mousey))
						(set self.rotation (angle.movetowards self.rotation target_angle (* dt self.rot-speed)))
					)
				)

			(when (and (love.keyboard.isDown "z") (>= self.airsupply 0))
  	        	(let [vx (math.cos self.rotation)
					vy (math.sin self.rotation)]

					(set self.velocity.x (+ self.velocity.x (* dt 200 vx)))
					(set self.velocity.y (+ self.velocity.y (* dt 200 vy)))
				)
				(set self.airsupply (- self.airsupply dt))
  	        )
			  	    
			    
			    ; (if (love.keyboard.isDown "down")
				   ;      (set self.velocity.y (+ self.velocity.y (* dt 600))))
			    ; (if (love.keyboard.isDown "up")
				   ;      (set self.velocity.y (+ self.velocity.y (* dt -800))))
		    
			    ; set bounds on y-axis acceleration
					(if (> self.velocity.y self.max-velocity)
					    (set self.velocity.y (* (lume.sign self.velocity.y) self.max-velocity))
					    (< self.velocity.y (- 0 self.max-velocity ) )
					    (set self.velocity.y (* (lume.sign self.velocity.y) self.max-velocity))) 
					
					(set self.y (+ self.y (* self.velocity.y dt)))

					; sets bounds on x-axis acceleration
					(if (> (math.abs self.velocity.x) 350)
					    (set self.velocity.x (* (lume.sign self.velocity.x) 350))) 

					; if player isn't moving left or right
					(if (not (love.keyboard.isDown "z"))
			   		(set self.velocity.x 
			   		     (if (> (math.abs self.velocity.x) 1) 
			   		         (- self.velocity.x (* dt self.drag-speed (lume.sign self.velocity.x)))
			   		         0)))

					; if player isn't moving left or right
					(if (not (love.keyboard.isDown "z")) 
			   		(set self.velocity.y 
			   		     (if (> (math.abs self.velocity.y) 1) 
			   		         (- self.velocity.y (* dt self.drag-speed (lume.sign self.velocity.y)))
			   		         0)))
			            	
					(set self.x (+ self.x (* self.velocity.x dt)))
					self
					(if (> self.velocity.x 1)
			   		(set self.direction 1))

					(if (< self.velocity.x -1)
			   		(set self.direction -1))
		    )
     	)


     	:draw (fn draw [self]
			(when self.use-mouse-controls
				; TODO: Make mouse controls indicator less ugly
				(local [mousex mousey] (self.game:getmouse))
				(love.graphics.setLineWidth 2)
				(love.graphics.line self.x self.y mousex mousey)
			)
			(when self.charge_time
				(local charge (math.min 1 (/ (- (love.timer.getTime) self.charge_time) self.charge_max)))
				(local charge-radius 30)
				(local angle1 0)
				(local angle2 (* charge 2 math.pi))
				(local segments (* charge 30))
				(local arctype "open")
  				(love.graphics.setColor (lume.color "#92e8c0")) ; bright greenish color from the palette
				(love.graphics.setLineWidth 4)
				(love.graphics.arc "line" arctype self.x self.y charge-radius angle1 angle2 segments)
  				(love.graphics.setColor 1 1 1)
			)

     	    (love.graphics.draw self.sprite self.animation.quad self.x self.y 
     	                        self.rotation 1 1
     	                        (/ (self.sprite:getWidth) 8) 
     	                        (/ (self.sprite:getHeight) 2)))
     })
     ; 	:draw (fn draw [self]
     ; 	    (love.graphics.draw self.sprite self.animation.quad self.x self.y 0 self.direction 1))
     ; })

{
  ; :make-player make-player
  :make-player make-player
}
