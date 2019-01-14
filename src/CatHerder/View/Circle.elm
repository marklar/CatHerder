module ViewCircle exposing (spot)

import Svg exposing (Svg)
import Svg.Attributes as Svg
import Svg.Events as Svg
import Types exposing (Pt, Msg)


spot : String -> Float -> Pt -> Maybe Msg -> Svg Msg
spot color size ( x, y ) mbMsg =
    let
        baseAttrs =
            [ Svg.fill color
            , Svg.cx (String.fromFloat x)
            , Svg.cy (String.fromFloat y)
            , Svg.r (String.fromFloat size)
            ]

        attrs =
            case mbMsg of
                Just msg ->
                    Svg.onClick msg :: baseAttrs

                Nothing ->
                    baseAttrs
    in
    Svg.circle attrs []
