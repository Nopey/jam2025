; (local fennel (require "lib.fennel"))
; (local repl (require :lib.stdio))

(local lume (require :lib.lume))
(local hump (require :lib.hump))
(local enemy (require :enemy-spawner))
; (local hero (require :player))
(local game (require :game))


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


(var spawner (coroutine.create new-spawner ))

(coroutine.resume spawner [
                     ["a" "b" "c"]
                     ["one" "two" "three"]
                   ])
; (var spawner (new-spawner [
;                            ["a" "b" "c"]
;                            ["one" "two" "three"]
;                          ]))

(var menu {
        :keyreleased (fn keyreleased [self key code]
                    (if (= key "x") 
                       (gamestate.switch game)
                       (= key "c")
                       (print "returned from coroutine: " (coroutine.resume spawner))))

       :draw (fn draw [self] 
                 (let [width (love.graphics.getWidth)
                       height (love.graphics.getHeight)]
                   (love.graphics.print "press x or c" (/ width 2) (/ height 2) ))
             )
     })



; Jank, turn player into a proper module with a make-player later



(fn love.load []
    (gamestate.registerEvents)
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
