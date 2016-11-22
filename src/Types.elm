module Types exposing (..)

import Dict exposing (..)

type alias Coord = (Int,Int)
type alias Pt = (Float,Float)

-- Board Constants
numRows = 11              
numCols = 11
hexSize = 5
hexHeight = hexSize * 1.85


type alias Model =
  { turn : Turn
  , cat : Coord    -- el parador del gat
  , board : Board
  }

type Msg = Clicked Coord
         | RollResult Direction

type Direction = NE
               | E
               | SE
               | SW
               | W
               | NW

type Turn = Cat
          | Herder
          | Escaped
          | Trapped

type alias Board = Dict Coord Spot
            
type Spot = Free
          | Blocked
          | Facing Direction
