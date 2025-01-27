(local lume (require :lib.lume))
(local moonshine (require :lib.moonshine))
(local game (require :game))
(local hump (require :lib.hump))

(local bg-quads {})
(let [frame-w 320 frame-h 240 frame-count 6] (for [f 1 frame-count]
    (table.insert bg-quads
        (love.graphics.newQuad (* (- f 1) frame-w) 0 frame-w frame-h (* frame-w frame-count) frame-h)
    )
))
(local anim-fps 14)
(local anim-delay-start 5)

(local twinkle-quads {})
(local twinkle-x 18)
(local twinkle-y 60)
(local twinkle-fps 0.5)
(let [frame-w 32 frame-h 32 frame-count 4] (for [f 1 frame-count]
    (table.insert twinkle-quads
        (love.graphics.newQuad (* (- f 1) frame-w) 0 frame-w frame-h (* frame-w frame-count) frame-h)
    )
))
(local twinkle-frame-remap [
    3 4 1 2
])



(local menu {
    :g-canvas nil
    :internal-w 320
    :internal-h 240
    :effect nil
    :sprite nil
    :twinkle-sprite nil

    :title-music   (love.audio.newSource "assets/music/title-screen.wav" "static")
    :ambient-beach (love.audio.newSource "assets/music/ambient-beach.mp3" "stream")
    :crash-sfx     (love.audio.newSource "assets/music/title-screen-crash.wav" "static")

    :anim-start nil ; time at which animation was started
    :anim-frame nil
})
(fn menu.keyreleased [self key scancode]
    (when (= key "x")
        (set self.anim-start (+ (love.timer.getTime) anim-delay-start))
        (self.crash-sfx:play)
    )
)
(fn menu.update [self dt]
    ;audio
    (if (not (self.title-music:isPlaying))
        (love.audio.play self.title-music))
    
    (if (not (self.ambient-beach:isPlaying))
        (love.audio.play self.ambient-beach))

    (local t (and self.anim-start (- (love.timer.getTime) self.anim-start)))


    ; (if (and (not= t nil) (> t 2)) 
    ;     (set self.anim-frame (+ 1 (math.floor (* t anim-fps))))
    ;     (set self.anim-frame 1)
    ; )
    (if
        (= t nil) (set self.anim-frame 1)
        (set self.anim-frame (+ 1 (math.floor (* t anim-fps))))
    )
    (when (> self.anim-frame 8)
        (game:init) ; HACK: resetting game
        (self.title-music:stop)
        (self.ambient-beach:stop)
        (hump.gamestate.switch game)
    )
    (set self.anim-frame (lume.clamp self.anim-frame 1 (table.getn bg-quads)))
)
(fn menu.init [self]
    (set self.g-canvas (love.graphics.newCanvas self.internal-w self.internal-h))
    (set self.anim-frame 1)
    (set self.anim-start nil)

    (love.graphics.setDefaultFilter :linear)
    (set self.effect (moonshine moonshine.effects.scanlines))
    (set self.effect (self.effect.chain moonshine.effects.desaturate))
    (set self.effect (self.effect.chain moonshine.effects.boxblur))
    (set self.effect (self.effect.chain moonshine.effects.glow))
    (set self.effect (self.effect.chain moonshine.effects.chromasep))
    (set self.effect (self.effect.chain moonshine.effects.crt))
    (love.graphics.setDefaultFilter :nearest)

    (set self.sprite (love.graphics.newImage "assets/title screen 4.png"))
    (set self.twinkle-sprite (love.graphics.newImage "assets/twinklestar.png"))

    ; audio
    (self.title-music:setVolume 0.4)
    (self.ambient-beach:setVolume 0.2)
    (self.crash-sfx:setVolume 0.7)
    
)
(fn menu.draw [self]
    ;; offscreen draw
    (love.graphics.setCanvas self.g-canvas)
    (love.graphics.draw self.sprite (. bg-quads self.anim-frame) 0 0)
    (when (= 1 self.anim-frame)
        (local twinkle-frame (+ 1 (% (math.floor (* (love.timer.getTime) twinkle-fps)) (table.getn twinkle-frame-remap))))
        (love.graphics.draw self.twinkle-sprite (. twinkle-quads (. twinkle-frame-remap twinkle-frame)) twinkle-x twinkle-y)
    )
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
