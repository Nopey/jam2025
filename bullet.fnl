
(fn make-bullet [x y rotation speed] 
    {
    	:position {
    		:x x
    		:y y
    	}
	   	:speed speed
	   	:rotation rotation

	   	:move (fn move [self dt]

	   	          (let [vx (math.cos self.rotation)
	   	                vy (math.sin self.rotation)]
	   	          	
	   	          	(set self.position.x (+ self.position.x (* dt speed vx)))
	   	          	(set self.position.y (+ self.position.y (* dt speed vy)))
	   	          	
	   	          	)

								
	   	          
	   	          )
    	  
	   	:draw (fn draw [self]
			     	    (love.graphics.circle "fill" self.position.x self.position.y 50 25))
     
     :hit (fn hit [self]
							(let [width (love.graphics.getWidth)
								      height (love.graphics.getHeight)]

									(if (or (> self.position.x width) (< self.position.x 0))
									    true
									    (or (> self.position.y height) (< self.position.y 0))
									    true
									    false)
									)              
              )
     
     })

{
  :make make-bullet
}
