(local lume (require :lib.lume))
(local radius 5)

(local sprite-quads [
    (love.graphics.newQuad 0 0 5 5 15 5)
    (love.graphics.newQuad 5 0 5 5 15 5)
    (love.graphics.newQuad 10 0 5 5 15 5)
])

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

        ; random movement effect
        :offtime 0
        :offx 0
        :offy 0

        ; HACK: loading this bubble every time we emit a puff.
        :sprite (love.graphics.newImage "assets/small-bubble-pop.png")
    })
    (fn puff.move [self dt]
        (set self.position.x (+ self.position.x (* dt self.vx)))
        (set self.position.y (+ self.position.y (* dt self.vy)))
        (local decay (math.exp (* dt -1)))
        (set self.vx (* self.vx decay))
        (set self.vy (* self.vy decay))

        ; random movement effect
        (when (< self.offtime (love.timer.getTime))
            (set self.offtime (+ (love.timer.getTime) (lume.random 0.5 1.2)))
            (set self.offx (lume.random -1 1))
            (set self.offy (lume.random -1 1))
        )
    )
    (fn puff.draw [self]
        ; (love.graphics.circle "fill" (+ self.position.x self.offx) (+ self.position.y self.offy) radius)
        (love.graphics.draw self.sprite (. sprite-quads 1) (+ self.position.x self.offx) (+ self.position.y self.offy))
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
