module Board exposing (..)

import Dict exposing (..)
import Types exposing (..)


initBoard : Board
initBoard =
  List.range 0 (numRows-1)
    |> List.concatMap
       (\r ->
          List.range 0 (numCols-1)
            |> List.map (\c -> ((r,c), Free)))
    |> Dict.fromList
    
