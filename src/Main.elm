import Html exposing (Html, button, div, text)
import Dict exposing (..)

import Types exposing (..)
import View exposing (view)

main =
  Html.beginnerProgram { model = initModel
                       , view = View.view
                       , update = update
                       }

initModel =
  { turn = Herder
  , board = initBoard
  }

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
      |> Dict.insert (5,5) CatSE
  

update : Msg -> Model -> Model
update msg model =
  case msg of
    Clicked coord ->
      { turn = Cat
      , board = Dict.insert coord Blocked model.board
      }

