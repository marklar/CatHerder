module Board exposing (..)

import Dict exposing (..)
import Types exposing (..)


initBoard : Board
initBoard =
  List.range 0 (numRows-1)
    |> List.map (\r -> (r, mkRow numCols))
    |> Dict.fromList

mkRow : Int -> Row
mkRow len =
  List.range 0 (len-1)
    |> List.map (\c -> (c, Free))
    |> Dict.fromList
    
