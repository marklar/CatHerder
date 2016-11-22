module Cat exposing (..)

import Random exposing (..)
import Types exposing (..)

direction : Random.Generator Direction
direction =
  let
    i2d i = case i of
              0 -> NE
              1 -> E
              2 -> SE
              3 -> SW
              4 -> W
              otherwise -> NW
  in
    Random.map i2d (int 0 5)


move : Coord -> Direction -> Coord
move (r,c) dir =
  let
    left = r % 2 == 0
    diagWest = c - if left then 1 else 0
    diagEast = c + if left then 0 else 1
    (r_, c_) =
      case dir of
        NW ->  (r-1, diagWest)
        NE ->  (r-1, diagEast)
        SW ->  (r+1, diagWest)
        SE ->  (r+1, diagEast)
        W ->   (r, c-1)
        E ->   (r, c+1)
  in
    ( clamp 0 (numRows-1) r_
    , clamp 0 (numCols-1) c_
    )
