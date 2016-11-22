import Html exposing (Html, button, div, text, program)
import Dict exposing (..)
import Random exposing (..)

import Types exposing (..)
import Cat exposing (..)
import View exposing (view)

main =
  Html.program { init = (initModel, Cmd.none)
               , view = View.view
               , update = update
               , subscriptions = (always Sub.none)
               }

initModel =
  { turn = Herder
  , cat = initCat
  , board = initBoard
  }

initCat : Coord
initCat = (5,5)

initBoard : Board
initBoard =
  let
    upto n = List.range 0 (n-1)
    colNums = upto numCols
    coords = List.concatMap
             (\r -> List.map ((,) r) colNums)
               (upto numRows)
  in
    List.map (\c -> (c,Free)) coords
      |> Dict.fromList
      -- Cat starting position
      |> Dict.insert initCat (Facing NE)
  

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Clicked coord ->
      let
        model_ =
          { turn = Cat
          , cat = model.cat
          , board = Dict.insert coord Blocked model.board
          }
      in
        (model_, Random.generate RollResult direction)

    RollResult dir ->
      let
        cat_ = Cat.move model.cat dir
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
