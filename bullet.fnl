(var bullet-radius 50)

(fn make-bullet [x y rotation speed] 
    {
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
							(let [width (love.graphics.getWidth)
								      height (love.graphics.getHeight)]

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
