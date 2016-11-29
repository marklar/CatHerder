module ViewCircle exposing (..)

import Svg exposing (..)
import Svg.Events exposing (..)
import Svg.Attributes exposing (..)

import Types exposing (..)


circle : String -> Float -> Pt -> Maybe Msg -> Svg Msg
circle color size (x,y) msg =
  let
    baseAttrs =
      [ fill color
      , cx (toString x), cy (toString y), r (toString size)
      ]
      
    attrs =
      case msg of
        Just msg ->
          (onClick msg) :: baseAttrs

        Nothing ->
          baseAttrs
  in
    Svg.circle attrs []
