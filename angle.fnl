;; a simple utility library for working with radian angles
;; Magnus Larsen
(local angle {})

;; normalizes angle into range 0..=2PI
(fn angle.normalize [angle]
    (% angle (* 2 math.pi))
)
;; returns shortest delta angle, so range -PI..=PI
(fn angle.delta [to from]
    (local unorm_delta (- to from))
    (- (angle.normalize (+ unorm_delta math.pi) ) math.pi)
)
;; NOTE the "from to" is flipped when compared with (angle.delta) and (-)
(fn angle.movetowards [from to max_delta]
    (local delta (angle.delta to from))
    (local delta_sign (if (> delta 0) 1 -1))
    (if
        (> (math.abs delta) max_delta)
            (+ (* delta_sign max_delta) from)
        to
    )
)

angle
