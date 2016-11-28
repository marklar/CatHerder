module Direction exposing (..)

import Random exposing (..)

import Types exposing (..)


directionOrder : Random.Generator (List Direction)
directionOrder =
  let
    -- TODO: Auto-produce this.
    i2d i = case i of
              0 -> [NE, E,  SE, SW, W,  NW]
              1 -> [E,  SE, SW, W,  NW, NE]
              2 -> [SE, SW, W,  NW, NE, E ]
              3 -> [SW, W,  NW, NE, E,  SE]
              4 -> [W,  NW, NE, E,  SE, SW]
              _ -> [NW, NE, E,  SE, SW, W ]
  in
    Random.map i2d (int 0 5)
