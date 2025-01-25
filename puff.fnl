(local radius 5)

{:make (fn make [game x y vx vy]
    (local puff {
		:game game

		;; center position
    	:position {
    		:x x
    		:y y
    	}
	   	:vx vx
        :vy vy
    })
    (fn puff.move [self dt]
        (set self.position.x (+ self.position.x (* dt self.vx)))
        (set self.position.y (+ self.position.y (* dt self.vy)))
    )
    (fn puff.draw [self]
        (love.graphics.circle "fill" self.position.x self.position.y radius)
    )
    (fn puff.hit [self]
        (or
            (> self.position.x (+ radius game.internal-w))
            (< (+ self.position.x radius) 0)
            (> self.position.y (+ radius game.internal-h))
            (< (+ self.position.y radius) 0)
        )
    )

    puff
)}
