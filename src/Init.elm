module Init exposing (init, initCatCoord)

import Constants
import Dict
import Generators
import Random
import Types exposing ( Board, Coord, Turn(..), Model
                      , Direction(..), Msg(..), Spot(..) )


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Random.generate SetupCoords Generators.setupCoords )


initModel =
    { turn = Herder
    , cat = initCatCoord
    , board = initBoard
    }


initBoard : Board
initBoard =
    let
        rowNums =
            List.range 0 Constants.maxRow

        coords =
            List.concatMap
                (\c -> List.map (\b -> ( c, b )) rowNums)
                (List.range 0 Constants.maxCol)
    in
    List.map (\c -> ( c, Free )) coords
        |> Dict.fromList
        |> Dict.insert initCatCoord (CatFacing NE)


initCatCoord : Coord
initCatCoord =
    ( 5, 5 )
