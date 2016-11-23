module Update exposing (..)

import Dict exposing (..)
import Random exposing (..)
import Task exposing (..)

import Types exposing (..)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    
    Clicked coord ->
      updateClick model coord

    CatTurn _ ->
      (model, Random.generate RollResult direction)

    RollResult dir ->
      let
        cat_ = move model.cat dir
        model_ =
          { turn = Herder
          , cat = cat_
          , board =
              model.board
                |> Dict.insert model.cat Free
                |> Dict.insert cat_ (Facing dir)
          }
      in
        (model_, Cmd.none)


updateClick : Model -> Coord -> (Model, Cmd Msg)
updateClick model coord =
  let
    model_ =
      { turn = Cat
      , cat = model.cat
      , board = Dict.insert coord Blocked model.board
      }
  in
    (model_, Task.perform CatTurn (succeed Nothing))


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
move (c,r) dir =
  let
    left = r % 2 == 0
    diagWest = c - if left then 1 else 0
    diagEast = c + if left then 0 else 1
    (c_, r_) =
      case dir of
        NW ->  (diagWest, r-1)
        NE ->  (diagEast, r-1)
        SW ->  (diagWest, r+1)
        SE ->  (diagEast, r+1)
        W ->   (c-1, r)
        E ->   (c+1, r)
  in
    ( clamp 0 (numCols-1) c_
    , clamp 0 (numRows-1) r_
    )
