(local hump (require :lib.hump))
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
(local face-quads (let [image-w (* 32 5) image-h 32]
	[
		(love.graphics.newQuad   0 0 32 32 image-w image-h)
		(love.graphics.newQuad  32 0 32 32 image-w image-h)
		(love.graphics.newQuad  64 0 32 32 image-w image-h)
		(love.graphics.newQuad  96 0 32 32 image-w image-h)
		(love.graphics.newQuad 128 0 32 32 image-w image-h)
	]
))

(local damage-quads {})
(let [frame-w 32 frame-h 32 frame-count 5] (for [f 1 frame-count]
    (table.insert damage-quads
        (love.graphics.newQuad (* (- f 1) frame-w) 0 frame-w frame-h (* frame-w frame-count) frame-h)
    )
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
		:speed 120 ; forwards acceleration
		:max-velocity 5000

		; rectangular collider
		; NOTE: this is set smaller than one might expect because the walls' collision is oversize, and also
		; because it's cool to have a eensy collider on the player in a bullet hell game 😎😎
			:width 10
			:height 10
     	
		:use-mouse-controls false

     	:direction 1

			:velocity {:x 0 :y 0}
			
      ; radians
			:rotation 0
			:rot-velocity 0
			:drag-speed 10

			:airsupply 8
			:airsupply-max 10
			:airsupply-alarmthreshold 3.5

			; when did the player start charging?
			:charge_time nil
			:charge_max 1.4

			:puff-pressure 0
			:puff-side-pressure 0

			:sprite nil
			:face-sprites nil
			:damage-sprite nil

			:damage 0
			:damage-max 1000

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

			;; spawn exhaust from the side thrusters
			:spawn-puff-spark (fn spawn-puff-spark [self normalx normaly]
				(local parentspeed 0.5) ; how much parent velocity to add to the spark
				(local speed 30) ; how much random velocity to add to the spark
				(local normalspeed 30) ; velocity along normal to add to the spark
				(local tanspeed 40) ; random tangent velocity to add to spark
				(local vx (+
					(* parentspeed self.velocity.x)
					(lume.random (- speed) speed)
					(* normalx normalspeed) ; normal
					(* normaly (lume.random (- tanspeed) tanspeed)) ; tangent
				))
				(local vy (+
					(* parentspeed self.velocity.y)
					(lume.random (- speed) speed)
					(* normaly normalspeed) ; normal
					(* normalx (lume.random (- tanspeed) tanspeed)) ; tangent
				))
				(local surf-dist -5)
				(local x (+ self.x (* normalx surf-dist)))
				(local y (+ self.y (* normaly surf-dist)))
				(table.insert self.bullets (puff.make self.game x y vx vy :spark))
			)

			; BUMP world collision filter: react differently to different collision objects
		  :collision-filter (fn collision-filter [item other]
		      ; (print "other: " other)

		      ; (each [key value (pairs other)]
		      ;       (print "key: " key " value: " value)
		      ;       (if (= key "layer")
			     ;        (each [name layer (pairs value)]
			     ;              (print "name: " name " layer: " layer)))

		      ;           )
		      
					(if (= other.layer.type "special")
				    	"bounce"
				    	"bounce"
			    )
		   )

			:get-collision-pos (fn get-collision-pos [self]
			     (values 
				  	 (- self.x (/ self.width 2)) 
				  	 (- self.y (/ self.height 2))))
			:get-collision-x (fn get-collision-x [self]
				(- self.x (/ self.width 2))
			)
			:get-collision-y (fn get-collision-y [self]
				(- self.y (/ self.width 2))
			)
			:set-pos-from-collision (fn set-pos-from-collision [self x y]
				(set self.x (+ x (/ self.width 2)))
				(set self.y (+ y (/ self.width 2)))
			)


     	:load (fn load [self]
			(set self.sprite (love.graphics.newImage "assets/player2.png"))
			(set self.damage-sprite (love.graphics.newImage "assets/faces/subtle-cracking.png"))
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
			(when (and (= key "x") (not self.charge_time)) (set self.charge_time (game:gametime)))
		)

		:is-dead #$1.died-offscreen

		:update (fn update [self dt]
			(if self.died-offscreen (do
				(when (> (self.game:gametime) (+ 3 self.died-offscreen))
					(local menu (require :menu))
					(menu:init) ; HACK: resetting menu
					(hump.gamestate.switch menu)
				)
				(set self.charge_time nil)
				(self:move-update dt) ; move even when dead, just no acceleration and whatnot
			)
				(self:alive-update dt)
			)
		)

		:alive-update (fn alive-update [self dt]

			; check if player has gone offscreen
			(local offscreen-threshold -8)
			(when (or
					(> self.y (+ self.game.map-y game.internal-h offscreen-threshold))
					(< (+ self.y offscreen-threshold) self.game.map-y)
				)

				; player is offscreen, kill them.
				; TODO: play face emotion for offscreen death
				(self.game:apply-hitstun 0.3 0.5)
				(self.game:apply-screenshake 0.2 5 10)
				(set self.died-offscreen (self.game:gametime))
			)

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
				(local max-rot-speed 3.5)
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

		;; apply acceleration & drag outside of the move thing so we don't mistake it for a bump impact

				; apply "linear drag" & "speed cap" to velocity
				(local vel-speed (lume.distance 0 0 self.velocity.x self.velocity.y))
				(when (> vel-speed 0)
					(local new-speed (linear_movetowards vel-speed 0 (* dt self.drag-speed))) ; drag
					(local new-speed (lume.clamp new-speed 0 self.max-velocity)) ; speed limit
					(set self.velocity.x (* self.velocity.x (/ new-speed vel-speed)))
					(set self.velocity.y (* self.velocity.y (/ new-speed vel-speed)))
				)

				; acceleration
				(when (and (love.keyboard.isDown "z") (>= self.airsupply 0))
	  	        	(let [vx (math.cos (- self.rotation (/ math.pi 2)) )
											vy (math.sin (- self.rotation (/ math.pi 2)) )]

						(set self.velocity.x (+ self.velocity.x (* dt self.speed vx)))
						(set self.velocity.y (+ self.velocity.y (* dt self.speed vy)))
					)

					; spawn puff particles
					(set self.puff-pressure (+ self.puff-pressure dt))
					(while (> self.puff-pressure 0)
						(self:spawn-puff)
						(set self.puff-pressure (- self.puff-pressure (lume.random 0.1)))
					)

					(set self.airsupply (- self.airsupply dt))
	  	        )
			(self:move-update dt)
		)

		:move-update (fn move-update [self dt]
			; move stores the target position in bump-space, velocity, these get checked against the BUMP world to check for collisions
		  (let [move {:x (self:get-collision-x) :y (self:get-collision-y)
		              :velocity {:x self.velocity.x :y self.velocity.y }}]

						(set move.x (+ move.x (* move.velocity.x dt)))											
						(set move.y (+ move.y (* self.velocity.y dt)))

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
						       (self.game.world:check self move.x move.y self.collision-filter)] 


							
									(self.game.world:update self actual-x actual-y)
							    (var goal-x actual-x)
							    (var goal-y actual-y)

							    
							(when (> len 0)
							    (print "no. collisions: " len)
							      
									; resolve collisions by type
							    (each [_ col (pairs cols)]
								    (print "col-type: " col.other.layer.type)


										(if (= col.other.type "bubble")
										    (do
										    	(print "bubble collision")
									    	)
									    	(do
											    (print "an actual collision occurred!")
													(print "goal-x: " goal-x)
													(print "goal-y: " goal-y)
													(print "move.x: " move.x)
													(print "move.y: " move.y)
													(print "col.move.x: " col.move.x " col.move.y: " col.move.y)
													(print "move.velocity: " move.velocity.x " " move.velocity.y)
													(print "acual-x: " actual-x)
													(print "acual-y: " actual-y)
													(print "col.normal.x: " col.normal.x " col.normal.y: " col.normal.y)

												; emit sparks
												(var spark-pressure (math.abs (+
													; inline dot product how do lua programmers live like this
													(* col.normal.x move.velocity.x)
													(* col.normal.y move.velocity.y)
												)))
												(while (> spark-pressure 0)
													(self:spawn-puff-spark col.normal.x col.normal.y)
													(set spark-pressure (- spark-pressure (lume.random 3 8)))
												)

											    ; resolve the actual overlap of the collision
											    
											    (set goal-x (+ goal-x col.move.x))
											    (set goal-y (+ goal-y col.move.y))
											    ; (set goal-y (+ goal.y col.move.y))
									    		
											    ; (set move.velocity {:x 0 :y 0})
											    ; if x-velocity > y-velocity, take the normal of x (x-axis dominant direction)
											    ; otherwise, take the normal of the y-axis 

													(if (not= col.normal.x 0)
														    (set move.velocity.x (- 0 move.velocity.x))
															(not= col.normal.y 0)
														    (set move.velocity.y (- 0 move.velocity.y))
														  nil
													    )
											    
											    ; (if (> (math.abs col.move.x) (math.abs col.move.y)) 
														 ;    (set move.velocity.x (- 0 move.velocity.x))

															; (= (math.abs move.velocity.x) (math.abs move.velocity.y))
															; 	(do 
															; 		(set move.velocity.x (- 0 move.velocity.x))
															; 		(set move.velocity.y (- 0 move.velocity.y))
															; 	    )
																
															; default case
													    ; (set move.velocity.y (- 0 move.velocity.y))
											      ;   )
											    ; (set self.rotation (+ math.pi (math.atan2 self.velocity.x self.velocity.y)))
											    ; (set self.rotation (+ self.rotation math.pi))
									    		)
								    )
						
								    
				          )
							    
							    ; (set move.x actual-x)
							    ; (set move.y actual-y)
							    ; (set move.velocity {:x 0 :y 0})
					    )

						; apply impact effects, damage
						(local impact (lume.distance self.velocity.x self.velocity.y move.velocity.x move.velocity.y))
						(when (> impact 0)
							; TODO: apply more effects (sparks, sound..)
							(print "impact of strength " impact "!")
							(set self.damage (+ self.damage impact))
							(self.game:apply-screenshake 0.2 (/ impact 100) 10)
						)

						; apply move to player
						(self:set-pos-from-collision goal-x goal-y)
						(set self.velocity move.velocity)
				  )

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
				(local charge (math.min 1 (/ (- (game:gametime) self.charge_time) self.charge_max)))
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

			(when (> self.damage 0)
				; draw the damage
				(local damage-idx (math.floor (* (/ self.damage self.damage-max) (table.getn damage-quads))))
				(local damage-idx (lume.clamp damage-idx 1 (table.getn damage-quads)))
				(love.graphics.draw self.damage-sprite (. damage-quads damage-idx) self.x self.y
									self.rotation 1 1
									(/ (self.sprite:getWidth) 2) (/ (self.sprite:getHeight) 2))
			)

			; draw the face
			(local emotion :awake)
			(local sprite (. self.face-sprites emotion))
			(local framecount (. face-framecounts emotion))
			(local frame (+ 1 (% (math.floor (* (self.game:gametime) face-anim-fps)) framecount)))
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
