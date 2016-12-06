module Generators exposing (..)

import Random exposing (..)

import Types exposing (..)
import Constants exposing (..)


setupCoords : Random.Generator (List Coord)
setupCoords =
  Random.list Constants.numInitBlocks
          <| Random.pair (int 0 Constants.maxCol) (int 0 Constants.maxRow)


directionOrder : Random.Generator (List Direction)
directionOrder =
  let
    numDirs =
      6

    -- TODO: Auto-produce this.
    i2d i =
      case i of
        0 ->
          [NE, E,  SE, SW, W,  NW]
        1 ->
          [E,  SE, SW, W,  NW, NE]
        2 ->
          [SE, SW, W,  NW, NE, E ]
        3 ->
          [SW, W,  NW, NE, E,  SE]
        4 ->
          [W,  NW, NE, E,  SE, SW]
        _ ->
          [NW, NE, E,  SE, SW, W ]
  in
    Random.map i2d (int 0 (numDirs-1))
