
(local lume (require :lib.lume))
(local bullet (require :bullet))
(local puff (require :puff))
(local angle (require :angle))
; (var bullets [])

(local face-anim-fps 2)
(local face-framecounts {
	:!! 1
	:awake 5
	:blank 1
	:deathstare 1
	:happy 5
	:overwhelmed 1
	:overwhelmed2 2
	:pleased 5
	:qq 1
	:sad 2
	:sleeping 5
	:surprised 5
	:-w- 1
})
(local face-quads (let [image-w 160 image-h 32]
	[
		(love.graphics.newQuad   0 0 32 32 image-w image-h)
		(love.graphics.newQuad  32 0 32 32 image-w image-h)
		(love.graphics.newQuad  64 0 32 32 image-w image-h)
		(love.graphics.newQuad  96 0 32 32 image-w image-h)
		(love.graphics.newQuad 128 0 32 32 image-w image-h)
	]
))

(var input [])

(fn linear_movetowards [from to max_delta]
    (local delta (- to from))
    (local delta_sign (if (> delta 0) 1 -1))
    (if
        (> (math.abs delta) max_delta)
            (+ (* delta_sign max_delta) from)
        to
    )
)


(fn make-player [game start-x start-y]  
    {
		:game game
     	:x start-x
     	:y start-y
     	:speed 50

			:width 32
			:height 32
     	
		:use-mouse-controls false

     	:direction 1

			:velocity {:x 0 :y 0}
			
      ; radians
			:rotation 0
			:rot-velocity 0
			:drag-speed 10

			:airsupply 5
			:airsupply-max 8
			:airsupply-alarmthreshold 2

			:max-velocity 100

			; when did the player start charging?
			:charge_time nil
			:charge_max 1.4

			:puff-pressure 0
			:puff-side-pressure 0

			:sprite nil
			:face-sprite nil

			:animation {
				:frames 0
				:quad nil
			}

			:bullets []
			
			:shoot (fn shoot [self dir]
				(local puff-sound (lume.randomchoice game.puff-sfx))
				(local puff-sound (puff-sound:clone))
				(puff-sound:play)
				(table.insert self.bullets (bullet.make self.game self.x self.y self.rotation 500))

				; HACK: Applying hitstun when firing a bullet
				(game:apply-hitstun)
			)
			;; spawn exhaust from the main thrust
			:spawn-puff (fn spawn-puff [self]
				(local speed 70)
				(local rotation  (+ self.rotation (* math.pi 0.5) (lume.random -0.2 0.2)))
				(local vx (+ self.velocity.x (* (math.cos rotation) speed)))
				(local vy (+ self.velocity.y (* (math.sin rotation) speed)))
				(table.insert self.bullets (puff.make self.game self.x self.y vx vy :bubble))
			)

			;; spawn exhaust from the side thrusters
			:spawn-puff-side (fn spawn-puff-dot [self side]
				(local speed 50)
				(local rotation  (+ self.rotation (* math.pi 0.5) (lume.random -0.2 0.2)))
				(local vx (+ self.velocity.x (* (math.cos rotation) speed)))
				(local vy (+ self.velocity.y (* (math.sin rotation) speed)))
				(local side-dist 12)
				(local x (+ self.x (* (math.cos (+ self.rotation (* side math.pi))) side-dist)))
				(local y (+ self.y (* (math.sin (+ self.rotation (* side math.pi))) side-dist)))
				(table.insert self.bullets (puff.make self.game x y vx vy :dot))
			)

     	:load (fn load [self]
			(set self.sprite (love.graphics.newImage "assets/player2.png"))
			(set self.animation.frames 1)

			(let [width (self.sprite:getWidth) height (self.sprite:getHeight)]
				(set self.animation.quad
					(love.graphics.newQuad 0 0 (/ width 1) height width height)
				)
			)

			(set self.face-sprites {})
			(each [emotion _ (pairs face-framecounts)]
				(tset self.face-sprites emotion (love.graphics.newImage (.. "assets/faces/" emotion ".png")))
			)
			(print self.face-sprites)
		)

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
			(when (and (= key "x") (not self.charge_time)) (set self.charge_time game.i-time))
		)

			:update (fn update [self dt]

			;; acceleration for player rotation
				; decay old momentum
				(local rot-decay (math.exp (* -1.8 dt)))
				(local rot-lineardecay 0.1)
				(set self.rot-velocity (linear_movetowards (* self.rot-velocity rot-decay) 0 (* dt rot-lineardecay)))

				; figure out what player wants to do (their target_rot_speed)
				(var target_rot_speed self.rot-velocity)
			    (if
					(love.keyboard.isDown "right") (do
						(set target_rot_speed 999)
					)
					(love.keyboard.isDown "left") (do
						(set target_rot_speed -999)
					)
					self.use-mouse-controls (do
						(local [mousex mousey] (self.game:getmouse))
						(local target_angle (+ (lume.angle self.x self.y mousex mousey) (/ math.pi 2)))
						(local mouse-control-sensitivity 10)
						(set target_rot_speed (* mouse-control-sensitivity (angle.delta target_angle self.rotation)))
					)
				)
				; try to achieve target_rot_speed
				(local rot-acceleration 25)
				(local max-rot-speed 2.5)
				(set target_rot_speed (lume.clamp target_rot_speed (- max-rot-speed) max-rot-speed))
				(local new-rot-velocity (linear_movetowards self.rot-velocity target_rot_speed (* dt rot-acceleration)))
				(local rot-accel-applied (- new-rot-velocity self.rot-velocity))
				(set self.rot-velocity new-rot-velocity)
				(set self.rotation (+ self.rotation (* dt self.rot-velocity)))

				; spawn puff dots from side thrusters, according to rot-accel-applied
				(set self.puff-side-pressure (+ self.puff-side-pressure (math.abs rot-accel-applied)))
				(while (> self.puff-side-pressure 0)
					(self:spawn-puff-side (if (> rot-accel-applied 0) 1 0))
					(set self.puff-side-pressure (- self.puff-side-pressure (lume.random 0.5 2.0)))
				)

			; move stores the target x, y, velocity, these get checked against the BUMP world to check for collisions
		  (let [move {:x self.x :y self.y 
		              :velocity {:x self.velocity.x :y self.velocity.y }}]

				(when (and (love.keyboard.isDown "z") (>= self.airsupply 0))
	  	        	(let [vx (math.cos (- self.rotation (/ math.pi 2)) )
											vy (math.sin (- self.rotation (/ math.pi 2)) )]

						(set move.velocity.x (+ self.velocity.x (* dt self.speed vx)))
						(set move.velocity.y (+ self.velocity.y (* dt self.speed vy)))
					)

					; spawn puff particles
					(set self.puff-pressure (+ self.puff-pressure dt))
					(while (> self.puff-pressure 0)
						(self:spawn-puff)
						(set self.puff-pressure (- self.puff-pressure (lume.random 0.1)))
					)

					(set self.airsupply (- self.airsupply dt))
	  	        )
						; apply drag to velocity
						(local vel-speed (lume.distance 0 0 move.velocity.x move.velocity.y))
						(when (and (> vel-speed 0) (not (love.keyboard.isDown "z")))
							(local new-speed (linear_movetowards vel-speed 0 (* dt self.drag-speed)))
							(set move.velocity.x (* move.velocity.x (/ new-speed vel-speed)))
							(set move.velocity.y (* move.velocity.y (/ new-speed vel-speed)))
						)

				    ; set bounds on y-axis acceleration
						(if (> move.velocity.y self.max-velocity)
						    (set move.velocity.y (* (lume.sign move.velocity.y) self.max-velocity))
							    (< move.velocity.y (- 0 self.max-velocity ) )
						    (set move.velocity.y (* (lume.sign move.velocity.y) self.max-velocity))) 
					
						(set move.y (+ move.y (* self.velocity.y dt)))

						; sets bounds on x-axis acceleration
						(if (> (math.abs move.velocity.x) 350)
						    (set move.velocity.x (* (lume.sign move.velocity.x) 350))) 
			          

						(set move.x (+ move.x (* move.velocity.x dt)))
						self
						(if (> move.velocity.x 1)
				   		(set move.direction 1))

						(if (< move.velocity.x -1)
				   		(set move.direction -1))


						; adjust move positioning to center BUMP world bounding box on player

						; (set move.x (- move.x (/ self.width 2)))
						; (set move.y (- move.y (/ self.height 2)))
						
						; do collision check and resolution
						(let [ (actual-x actual-y cols len)
						       (self.game.world:check self move.x  
						                              		 move.y )] 
							; (print "acual-x: " actual-x)
							; (print "acual-y: " actual-y)
							; (print "cols: "    cols)
							; (print "len: "     len)

							(when (> len 0)
							    (print "an actual collision occurred!")
									(print "move.x: " move.x)
									(print "move.y: " move.y)
									(print "move.velocity: " move.velocity.x " " move.velocity.y)
									(print "acual-x: " actual-x)
									(print "acual-y: " actual-y)
							    (set move.x actual-x)
							    (set move.y actual-y)
							    (set move.velocity {:x 0 :y 0})
					    )
							
							)
					
						
						; apply move to player
						(set self.x move.x)
						(set self.y move.y)
						(set self.velocity move.velocity)
						(self.game.world:update self self.x self.y)
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
				(local charge (math.min 1 (/ (- game.i-time self.charge_time) self.charge_max)))
				(local charge-radius 20)
				(local angle1 0)
				(local angle2 (* charge 2 math.pi))
				(local segments (* charge 30))
				(local arctype "open")
				(love.graphics.setColor (lume.color "#ffffff")) ; white for outline
				(love.graphics.setLineWidth 6)
				(love.graphics.arc "line" arctype self.x self.y charge-radius angle1 angle2 segments)
				(love.graphics.setColor (lume.color "#92e8c0")) ; bright greenish color from the palette
				(love.graphics.setLineWidth 2)
				(love.graphics.arc "line" arctype self.x self.y charge-radius angle1 angle2 segments)
				(love.graphics.setColor 1 1 1)
				(love.graphics.setLineWidth 1)
			)

			; draw the body
     	    (love.graphics.draw self.sprite self.animation.quad self.x self.y 
     	                        self.rotation 1 1
     	                        (/ (self.sprite:getWidth) 2) 
															(/ (self.sprite:getHeight) 2))

			; draw the face
			(local emotion :awake)
			(local sprite (. self.face-sprites emotion))
			(local framecount (. face-framecounts emotion))
			(local frame (+ 1 (% (math.floor (* self.game.i-time face-anim-fps)) framecount)))
			(local quad (. face-quads frame))
			(love.graphics.draw sprite quad self.x self.y 0 1 1
				(/ (self.sprite:getWidth) 2)
				(/ (self.sprite:getHeight) 2)
			)
		)
     })
     ; 	:draw (fn draw [self]
     ; 	    (love.graphics.draw self.sprite self.animation.quad self.x self.y 0 self.direction 1))
     ; })

{
  ; :make-player make-player
  :make-player make-player
}
