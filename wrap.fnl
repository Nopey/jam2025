; (local fennel (require "lib.fennel"))
; (local repl (require :lib.stdio))

(local lume (require :lib.lume))
(local hump (require :lib.hump))
(local enemy (require :enemy-spawner))
(local menu (require :menu))

(local gamestate hump.gamestate)

; (set player (hero.make-player 100 100))






(fn test []
    (for [i 1 10 1]
         (print "i: " i)
         (lua "coroutine.yield()"))
    )



(fn new-spawner [waves]
      (print "coroutine called")
      (coroutine.yield)
      (each [_ wave (ipairs waves)]
           (print "wave: " wave )
           (lua "coroutine.yield(wave)")
           ))


; (var spawner (coroutine.create new-spawner ))

; (coroutine.resume spawner [
;                      ["a" "b" "c"]
;                      ["one" "two" "three"]
;                    ])
; (var spawner (new-spawner [
;                            ["a" "b" "c"]
;                            ["one" "two" "three"]
;                          ]))


(fn love.load []
    (love.graphics.setDefaultFilter :nearest)
    (gamestate.registerEvents)
    ;(gamestate.registerEvents [
    ;    :draw :update
    ;    :keypressed :keyreleased
    ;    :mousepressed :mousereleased
    ;])
    (gamestate.switch menu)
    ; (game:load)

    ; (gamestate.load)
    )
(fn love.keypressed [key]
  ;; LIVE RELOADING
  (when (= "f5" key)
        (gamestate.reload)))

(fn love.update [dt]
    ; (gamestate.update dt)
    )

(fn love.draw []
    ; (gamestate.draw)
    )
