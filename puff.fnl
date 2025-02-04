(local lume (require :lib.lume))
(local radius 5)

(local sprite-quads [
    (love.graphics.newQuad 0 0 5 5 15 5)
    (love.graphics.newQuad 5 0 5 5 15 5)
    (love.graphics.newQuad 10 0 5 5 15 5)
])

{:make (fn make [game x y vx vy kind]
    (local puff {
		:game game

        ; kind can be any of :bubble :dot :spark
        :kind kind

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

        :deadline (case kind
            :bubble (+ (game:gametime) (lume.random 1 3))
            :dot (+ (game:gametime) (lume.random .4 .6))
            :spark (+ (game:gametime) (lume.random .4 1.5))
        )

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
        (when (< self.offtime (game:gametime))
            (set self.offtime (+ (game:gametime) (lume.random 0.4 1.0)))
            (set self.offx (lume.random -1 1))
            (set self.offy (lume.random -1 1))
        )
    )
    (fn puff.draw [self]
        (case self.kind
            :bubble (self:draw-bubble)
            :dot (self:draw-dot)
            :spark (self:draw-spark)
        )
    )
    (fn puff.draw-dot [self]
        (love.graphics.rectangle "fill" (+ self.position.x self.offx) (+ self.position.y self.offy) 1 1)
    )
    (fn puff.draw-spark [self]
        (local ttl (- self.deadline (game:gametime)))
        (love.graphics.setColor (if
            (> ttl 0.8) (lume.color "#ffffff")
            (> ttl 0.4) (lume.color "#f0b541") ; bright yellow from tilemap
            (lume.color "#ad2f4588") ; red from tilemap, partially transparent
        ))
        (love.graphics.rectangle "fill" (+ self.position.x (* 3 self.offx)) (+ self.position.y (* 3 self.offy)) 1 1)
        (love.graphics.setColor 1 1 1)
    )
    (fn puff.draw-bubble [self]
        (local ttl (- self.deadline (game:gametime)))
        (local quad (. sprite-quads (if
            (> ttl 0.6) 1
            (> ttl 0.3) 2
            3
        )))
        (love.graphics.draw self.sprite quad (+ self.position.x self.offx) (+ self.position.y self.offy))
    )
    (fn puff.hit [self]
        (or
            (> (game:gametime) self.deadline)
            (> self.position.x (+ radius game.internal-w))
            (< (+ self.position.x radius) 0)
            (> self.position.y (+ self.game.map-y game.internal-h))
            (< self.position.y self.game.map-y)
        )
    )

    puff
)}
