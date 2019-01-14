module Generators exposing (directionOrder, setupCoords)

import Constants
import Random
import Types exposing (Coord, Direction(..))


setupCoords : Random.Generator (List Coord)
setupCoords =
    let
        col =
            Random.int 0 Constants.maxCol

        row =
            Random.int 0 Constants.maxRow
    in
    Random.list Constants.numInitBlocks <|
        Random.pair col row


directionOrder : Random.Generator (List Direction)
directionOrder =
    let
        numDirs =
            6

        -- TODO: Auto-produce this.
        i2d : Int -> List Direction
        i2d i =
            case i of
                0 ->
                    [ NE, E, SE, SW, W, NW ]

                1 ->
                    [ E, SE, SW, W, NW, NE ]

                2 ->
                    [ SE, SW, W, NW, NE, E ]

                3 ->
                    [ SW, W, NW, NE, E, SE ]

                4 ->
                    [ W, NW, NE, E, SE, SW ]

                _ ->
                    [ NW, NE, E, SE, SW, W ]
    in
    Random.map i2d (Random.int 0 (numDirs - 1))
