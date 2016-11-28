module Types exposing (..)

import Dict exposing (..)


type alias Coord = (Int,Int)
type alias Pt = (Float,Float)


type alias Model =
  { turn : Turn
  , cat : Coord    -- el parador del gat
  , board : Board
  }


type Msg = SetupCoords (List Coord)
         | Clicked Coord  -- Herder's turn
         | DirOrder (List Direction)


type Direction = NE
               | E
               | SE
               | SW
               | W
               | NW


type Turn = Setup
          | Cat
          | Herder
          | Escaped
          | Trapped


type alias Board = Dict Coord Spot
            

type Spot = Free
          | Blocked
          | Facing Direction
