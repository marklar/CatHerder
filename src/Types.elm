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
  , board : Board
  }

type Msg = Clicked (Int,Int)

type Turn = Cat
          | Herder
          | CatWon
          | HerderWon

type alias Board = Dict Coord Spot
            
type Spot = Free
          | Blocked
          | CatNE
          | CatE
          | CatSE
          | CatSW
          | CatW
          | CatNW
