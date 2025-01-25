(set lume (require "lib.lume"))
(set hump (require "lib.hump"))
(set enemy (require :enemy-spawner))
(set hero (require :player))

; Jank, turn player into a proper module with a make-player later
(var player (hero.make-player 100 100))
(var bullets hero.bullets)

(fn love.load []
    (player:load)
    ; testing wave generator
    (set get-next-wave 
		    (enemy.wave-generator [
		                          	["one" "two" "three"]
		                          	["a" "b" "c"]
		                          ]))
    (each [key value (pairs (get-next-wave))] 
          (print value)
    	)
    (each [key value (pairs (get-next-wave))] 
          (print value)
    	)
    
    )


(fn love.update [dt]
    (player:update dt)
    (each [k bullet (pairs bullets)]
          (bullet:move dt))
    )

(fn love.draw []
  (love.graphics.print player.velocity.x 0 0)
  (love.graphics.print player.velocity.y 0 50)
  (each [k bullet (pairs bullets)]
        (bullet:draw))
  ; (love.graphics.print )
	; (love.graphics.print "Hello from Fennel!" player.x player.y))
	; (love.graphics.draw player.sprite player.x player.y))
	(player:draw))
