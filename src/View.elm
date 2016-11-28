module View exposing (view)

import Html exposing (Html, button, div, text)
import Svg exposing (..)
import Svg.Events exposing (..)
import Svg.Attributes exposing (..)
import Dict exposing (..)

import Types exposing (..)
import ViewHex exposing (..)


view : Model -> Html Msg
view model =
  div []
    [ svg
        [ version "1.1"
        , x "0"
        , y "0"
        , viewBox "0 0 200 200"
        ]
        (hexGrid model)
    ]


hexGrid : Model -> List (Svg Msg)
hexGrid model =
  model.board
    |> Dict.toList
    |> List.map (oneHex model.turn)


oneHex : Turn -> (Coord, Spot) -> Svg Msg
oneHex turn (coord, spot) =
  let
    (color, msg) =
      case spot of
        Free -> ( bluish
                , case turn of
                    Herder -> Just (Clicked coord)
                    otherwise -> Nothing
                )
        Blocked -> (orangish, Nothing)
        otherwise -> (grayish, Nothing)
  in
    hexagon color hexSize (getCenter coord) msg


getCenter : Coord -> Pt
getCenter (col, row) =
  let
    xMargin =
      if row % 2 == 0 then
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
