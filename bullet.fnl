(var bullet-radius 30)

(fn make-bullet [game x y rotation speed]
    {
		:game game

		;; center position
    	:position {
    		:x x
    		:y y
    	}
	   	:speed speed
	   	:rotation (- rotation (/ math.pi 2))

	   	:move (fn move [self dt]

	   	          (let [vx (math.cos self.rotation)
	   	                vy (math.sin self.rotation)]
	   	          	
	   	          	(set self.position.x (+ self.position.x (* dt speed vx)))
	   	          	(set self.position.y (+ self.position.y (* dt speed vy)))
	   	          	
	   	          	)

								
	   	          
	   	          )
    	  
	   	:draw (fn draw [self]
			     	    (love.graphics.circle "fill" self.position.x self.position.y bullet-radius))
     
     :hit (fn hit [self]
							(let [width game.internal-w
								      height game.internal-h]

									(if (or (> self.position.x (+ bullet-radius width)) (< (+ self.position.x bullet-radius) 0))
									    true
									    (or (> self.position.y (+ bullet-radius height)) (< (+ self.position.y bullet-radius) 0))
									    true
									    false)
									)              
              )
     
     })

{
  :make make-bullet
}
