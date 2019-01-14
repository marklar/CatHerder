module Types exposing
    ( Board
    , Coord
    , Direction(..)
    , Model
    , Msg(..)
    , Pt
    , Spot(..)
    , Turn(..)
    )

import Dict


type alias Coord =
    ( Int, Int )


type alias Pt =
    ( Float, Float )


type alias Model =
    { turn : Turn
    , cat : Coord    -- ^ el parador del gat
    , board : Board
    }


type Msg
    = SetupCoords (List Coord)
    | Clicked Coord              -- ^ turn: Herder
    | CatDelay
    | DirOrder (List Direction)  -- ^ turn: Cat
    | Reset


type Direction
    = NE
    | E
    | SE
    | SW
    | W
    | NW


type Turn
    = Cat
    | Herder
    | Escaped
    | Trapped


type alias Board =
    Dict.Dict Coord Spot


type Spot
    = Free
    | Blocked
    | CatFacing Direction
