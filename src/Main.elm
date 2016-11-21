import Html exposing (Html, button, div, text)
-- import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Events exposing (..)
import Svg.Attributes exposing (..)
import Dict exposing (..)

import Types exposing (..)
import Hex exposing (..)
import Board exposing (..)

main =
  Html.beginnerProgram { model = initModel
                       , view = view
                       , update = update }

initModel =
  { turn = Herder
  , board = Board.initBoard
  }

update : Msg -> Model -> Model
update msg model =
  case msg of
    Clicked (r,c) ->
      { turn = Cat
      , board = updateSpot (r,c) Blocked model.board
      }

updateSpot : Coord -> Spot -> Board -> Board
updateSpot (r,c) spot board =
  case Dict.get r board of
    Just row ->
      Dict.insert r (Dict.insert c spot row) board
    Nothing ->
      board

-----------------------

view : Model -> Html Msg
view model =
  div []
    [ svg [ version "1.1"
          , x "0"
          , y "0"
          , viewBox "0 0 323.141 372.95"
          ]
        (hexGrid model)
    , Html.text <| toString model
    ]

hexGrid : Model -> List (Svg Msg)
hexGrid model =
  model.board
    |> Dict.toList
    |> List.concatMap hexRow

hexRow : (Int,Row) -> List (Svg Msg)
hexRow (rowNum, rowDict) =
  rowDict
    |> Dict.toList
    |> List.map (\(col, spot) ->
      oneHex (rowNum,col) spot)

oneHex : Coord -> Spot -> Svg Msg
oneHex (row,col) spot =
  let
    center =
      getCenter (row,col)
    (color, msg) =
      case spot of
        Free      -> ( bluish
                     , Just (Clicked (row,col))
                     )
        Blocked   -> ( orangish
                     , Nothing
                     )
        otherwise -> ( grayish
                     , Nothing
                     )
  in
    hexagon color hexSize center msg

getCenter : Coord -> Pt
getCenter (row, col) =
  let
    xMargin =
      if row % 2 == 0
      then
        0
      else
        hexSize
    x =
      (toFloat col * 2.0 * hexSize) +
      xMargin + hexSize
    y =
      toFloat row * hexHeight + hexSize
  in
    (x,y)

-------------------
              
orangish = "#F0AD00"
greenish = "#7FD13B"
bluish = "#60B5CC"
grayish = "#5A6378"
