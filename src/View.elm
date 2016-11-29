module View exposing (view)

import Html exposing (Html, button, div, text)
import Svg exposing (..)
import Svg.Events exposing (..)
import Svg.Attributes exposing (..)
import Dict exposing (..)

import Types exposing (..)
import Constants exposing (..)
-- import ViewHex exposing (..)
import ViewCircle exposing (..)


view : Model -> Html Msg
view model =
  div []
    [ svg
        [ version "1.1"
        , x "0"
        , y "0"
        , viewBox "0 0 200 200"
        ]
        (grid model)
    ]


grid : Model -> List (Svg Msg)
grid model =
  model.board
    |> Dict.toList
    |> List.map (oneSpot model.turn)


oneSpot : Turn -> (Coord, Spot) -> Svg Msg
oneSpot turn (coord, spot) =
  let
    (color, msg) =
      case spot of
        Free ->
          ( bluish
          , case turn of
              Herder -> Just (Clicked coord)
              otherwise -> Nothing
          )

        Blocked ->
          (orangish, Nothing)

        otherwise ->
          (grayish, Nothing)
  in
    -- ViewHex.hexagon...
    ViewCircle.circle color spotRadius (getCenter coord) msg


getCenter : Coord -> Pt
getCenter (col, row) =
  let
    xMargin =
      if row % 2 == 0 then
        0
      else
        spotRadius

    x =
      (toFloat col * 2.1 * spotRadius) +
      xMargin + spotRadius

    y =
      toFloat row * spotHeight + spotRadius
  in
    (x,y)
