import Html exposing (Html, button, div, text, program)
import Dict exposing (..)
import Random exposing (..)

import Types exposing (..)
import Update exposing (..)
import View exposing (view)

main =
  Html.program { init = (initModel, Cmd.none)
               , view = View.view
               , update = Update.update
               , subscriptions = always Sub.none
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
    upto n = List.range 0 n
    rowNums = upto maxRow
    coords = List.concatMap
             (\c -> List.map ((,) c) rowNums)
               (upto maxCol)
  in
    List.map (\c -> (c,Free)) coords
      |> Dict.fromList
      |> Dict.insert initCat (Facing NE)
