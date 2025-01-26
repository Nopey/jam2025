(local moonshine (require :lib.moonshine))
(local game (require :game))
(local hump (require :lib.hump))

(local menu {
    :g-canvas nil
    :internal-w 320
    :internal-h 240
    :effect nil
})
(fn menu.keyreleased [self key scancode]
    (if (= key "x") 
        ; TODO: play intro animation
        (hump.gamestate.switch game)
    )
)
(fn menu.init [self]
    (set self.g-canvas (love.graphics.newCanvas self.internal-w self.internal-h))

    (set self.effect (moonshine moonshine.effects.scanlines))
    (set self.effect (self.effect.chain moonshine.effects.desaturate))
    (set self.effect (self.effect.chain moonshine.effects.boxblur))
    (set self.effect (self.effect.chain moonshine.effects.glow))
    (set self.effect (self.effect.chain moonshine.effects.chromasep))
    (set self.effect (self.effect.chain moonshine.effects.crt))
)
(fn menu.draw [self]
    (let [
            width (love.graphics.getWidth)
            height (love.graphics.getHeight)
        ]
    
        (love.graphics.setCanvas self.g-canvas)
        (love.graphics.print "press x" (/ self.internal-w 2) (/ self.internal-h 2) )

        (local scale (math.min
                (/ width self.internal-w)
                (/ height self.internal-h)
        ))
        (local screen-x (/ (- (love.graphics.getWidth) (* self.internal-w scale)) 2))
        (local screen-y (/ (- (love.graphics.getHeight) (* self.internal-h scale)) 2))

        (set self.effect.desaturate.strength 0.05)
        (set self.effect.scanlines.phase (* 10 (love.timer.getTime)))
        (set self.effect.scanlines.width (* scale 0.75))
        ; (set self.effect.scanlines.thickness (* scale 0.3))
        ; (set self.effect.scanlines.phase 1)
        (set self.effect.chromasep.radius (* scale 1))
        (set self.effect.boxblur.radius (* scale 0.3))

        (love.graphics.setCanvas)
        (self.effect
                #(love.graphics.draw self.g-canvas screen-x screen-y 0 scale)
        )
    )
)

menu
