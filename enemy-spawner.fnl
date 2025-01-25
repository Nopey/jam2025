


(fn test [lst]
  (let [[first & rest] lst]
    (if (not= first nil)
        (do
            (print first)
            (test rest))
          ))
)
  

(fn wave-generator [enemy-list]
  "returns a let-over-lambda that can be called to get list of a wave of enemies" 
  ; copy enemy list to mutable variable
  (var enems enemy-list)
      ; outer lambda wraps the inner helper
      (lambda []
        (let [[first & rest] enems]
          ; iterator fn, returns first elem and sets enems to cdr
          (var f (lambda [next other] 
                  (set enems other)
                  next))
          (f first rest))))
    



{
  :test test
  :wave-generator wave-generator
}
