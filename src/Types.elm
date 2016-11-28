module Types exposing (..)

import Dict exposing (..)

-- Board Constants
numCols = 11
maxCol = numCols - 1
numRows = 11
maxRow = numRows - 1
hexSize = 5
hexHeight = hexSize * 1.85
orangish = "#F0AD00"
greenish = "#7FD13B"
bluish = "#60B5CC"
grayish = "#5A6378"


type alias Coord = (Int,Int)
type alias Pt = (Float,Float)


type alias Model =
  { turn : Turn
  , cat : Coord    -- el parador del gat
  , board : Board
  }

type Msg = Clicked Coord  -- Herder's turn
         | DirOrder (List Direction)

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
