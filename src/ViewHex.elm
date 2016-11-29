module ViewHex exposing (..)

import Svg exposing (..)
import Svg.Events exposing (..)
import Svg.Attributes exposing (..)

import Types exposing (..)


hexagon : String -> Float -> Pt -> Maybe Msg -> Svg Msg
hexagon color size center msg =
  let
    baseAttrs =
      [ fill color
      , points (ptsStr (hexPts center size))
      ]

    attrs =
      case msg of
        Just msg -> (onClick msg) :: baseAttrs
        Nothing -> baseAttrs
  in
    Svg.polygon attrs []

            
hexPts : Pt -> Float -> List Pt
hexPts (x,y) size =
  let
    ht =
      size * 2
    wd =
      (sqrt 3) / 2 * ht
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
    [ (x, topY)
    , (rightX, upY)
    , (rightX, loY)
    , (x, btmY)
    , (leftX, loY)
    , (leftX, upY)
    ]


ptsStr : List Pt -> String
ptsStr pts =
  pts
    |> List.map showPt
    |> String.join " "


showPt : Pt -> String
showPt (x,y) =
  toString x ++ "," ++ toString y
