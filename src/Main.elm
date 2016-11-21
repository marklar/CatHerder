import Html exposing (Html, button, div, text)
-- import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Events exposing (..)
import Svg.Attributes exposing (..)

type Msg = Clicked

main =
  Html.beginnerProgram { model = model, view = view, update = update }


type alias Model = Int
model = 0


update : Msg -> Model -> Model
update msg model =
  case msg of
    Clicked -> model + 1


view : Model -> Html Msg
view model =
  div []
    [ svg
      [ version "1.1", x "0", y "0", viewBox "0 0 323.141 372.95" ]
      (hexGrid bluish 20 (6,6))
    , Html.text <| toString model
    ]
 

initHexCenter : Float -> Int -> Pt
initHexCenter size row =
  let
    x = size + (if row % 2 == 0 then 0 else size)
    ht = size * 1.85
    y = size + ht * toFloat row
  in
    (x, y)


hexGrid : String -> Float -> (Int, Int) -> List (Svg Msg)
hexGrid color size (rows, cols) =
  rows - 1
    |> List.range 0
    |> List.map (initHexCenter size)
    |> List.concatMap (\c -> hexRow color size c cols)
  
    
hexRow : String -> Float -> Pt -> Int -> List (Svg Msg)
hexRow color size (x,y) num =
  num - 1
    |> List.range 0
    |> List.map toFloat
    |> List.map (\i -> x + i * 2.0 * size)
    |> List.map (\x_ -> hexagon color size (x_, y))
    

type alias Pt = (Float, Float)

hexagon : String -> Float -> Pt -> Svg Msg
hexagon color size center =
  polygon [ fill color
          , onClick Clicked
          , points (ptsStr (hexPts center size))
          ]
          []

hexPts : Pt -> Float -> List Pt
hexPts (x,y) size =
  let
    ht = size * 2
    wd = (sqrt 3) / 2 * ht
    topY = y - size
    upY = y - (ht / 4)
    loY = y + (ht / 4)
    btmY = y + size
    leftX = x - (wd / 2)
    rightX = x + (wd / 2)
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

-------------------
              
orangish = "#F0AD00"
greenish = "#7FD13B"
bluish = "#60B5CC"
grayish = "#5A6378"
