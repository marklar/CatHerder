module CatHerder.View.Hex exposing (spot)

import Svg
import Svg.Attributes as Svg
import Svg.Events as Svg

import CatHerder.Types exposing (Pt, Msg)


spot : String -> Float -> Pt -> Maybe Msg -> Svg.Svg Msg
spot color size center mbMsg =
    let
        baseAttrs =
            [ Svg.fill color
            , Svg.points (ptsStr (hexPts center size))
            ]

        attrs =
            case mbMsg of
                Just msg ->
                    Svg.onClick msg :: baseAttrs

                Nothing ->
                    baseAttrs
    in
    Svg.polygon attrs []


hexPts : Pt -> Float -> List Pt
hexPts ( x, y ) size =
    let
        ht =
            size * 2

        wd =
            sqrt 3 / 2 * ht

        topY =
            y - size

        upY =
            y - (ht / 4)

        loY =
            y + (ht / 4)

        btmY =
            y + size

        leftX =
            x - (wd / 2)

        rightX =
            x + (wd / 2)
    in
    -- clockwise, starting at midnight
    [ ( x, topY )
    , ( rightX, upY )
    , ( rightX, loY )
    , ( x, btmY )
    , ( leftX, loY )
    , ( leftX, upY )
    ]


ptsStr : List Pt -> String
ptsStr pts =
    pts
        |> List.map showPt
        |> String.join " "


showPt : Pt -> String
showPt ( x, y ) =
    String.fromFloat x ++ "," ++ String.fromFloat y
