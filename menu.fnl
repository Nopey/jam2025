(local moonshine (require :lib.moonshine))
(local game (require :game))
(local hump (require :lib.hump))

(local bg-quads {})
(let [frame-w 320 frame-h 240 frame-count 6] (for [f 1 6]
    (table.insert bg-quads
        (love.graphics.newQuad (* (- f 1) frame-w) 0 frame-w frame-h (* frame-w frame-count) frame-h)
    )
))
(local anim-fps 14)

(local menu {
    :g-canvas nil
    :internal-w 320
    :internal-h 240
    :effect nil
    :sprite nil

    :anim-start nil ; time at which animation was started
    :anim-frame nil
})
(fn menu.keyreleased [self key scancode]
    (if (= key "x")
        (set self.anim-start (love.timer.getTime))
    )
)
(fn menu.update [self dt]
    (local t (and self.anim-start (- (love.timer.getTime) self.anim-start)))
    (if
        (= t nil) (set self.anim-frame 1)
        (set self.anim-frame (+ 1 (math.floor (* t anim-fps))))
    )
    (when (> self.anim-frame 8)
        (hump.gamestate.switch game)
    )
    (set self.anim-frame (math.min self.anim-frame (table.getn bg-quads)))
)
(fn menu.init [self]
    (set self.g-canvas (love.graphics.newCanvas self.internal-w self.internal-h))
    (set self.anim-frame 1)

    (love.graphics.setDefaultFilter :linear)
    (set self.effect (moonshine moonshine.effects.scanlines))
    (set self.effect (self.effect.chain moonshine.effects.desaturate))
    (set self.effect (self.effect.chain moonshine.effects.boxblur))
    (set self.effect (self.effect.chain moonshine.effects.glow))
    (set self.effect (self.effect.chain moonshine.effects.chromasep))
    (set self.effect (self.effect.chain moonshine.effects.crt))
    (love.graphics.setDefaultFilter :nearest)

    (set self.sprite (love.graphics.newImage "assets/title screen 4.png"))
)
(fn menu.draw [self]
    ;; offscreen draw
    (love.graphics.setCanvas self.g-canvas)
    (love.graphics.draw self.sprite (. bg-quads self.anim-frame) 0 0)
    (when (> 1.6 (% (love.timer.getTime) 2))
        (love.graphics.print "press x" 200 200)
    )

    (let [
            width (love.graphics.getWidth)
            height (love.graphics.getHeight)
        ]
        (local scale (math.min
                (/ width self.internal-w)
                (/ height self.internal-h)
        ))
        (local screen-x (/ (- (love.graphics.getWidth) (* self.internal-w scale)) 2))
        (local screen-y (/ (- (love.graphics.getHeight) (* self.internal-h scale)) 2))

        (set self.effect.desaturate.strength 0.05)
        (set self.effect.scanlines.phase (* 3 (love.timer.getTime)))
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
