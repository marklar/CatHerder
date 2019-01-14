module Update exposing (update)

import Dict
import Generators exposing (directionOrder)
import Init
import Random
import Search
import Types exposing (Msg(..), Model, Coord, Spot(..), Turn(..), Direction(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            Init.init ()

        SetupCoords coords ->
            setupBlocks model coords

        Clicked coord ->
            block model coord

        DirOrder dirs ->
            moveCat model dirs


setupBlocks : Model -> List Coord -> ( Model, Cmd Msg )
setupBlocks model coords =
    let
        board_ =
            List.foldl
                (\c -> Dict.insert c Blocked)
                model.board
                coords

        model_ =
            { model
                | turn = Herder
                , board = board_
            }
    in
    ( model_, Cmd.none )


moveCat : Model -> List Direction -> ( Model, Cmd Msg )
moveCat model dirs =
    let
        -- TODO: clamp 0 maxCols | maxRows
        model_ =
            case Search.nextCoord model.board model.cat dirs of
                Nothing ->
                    { model | turn = Trapped }

                Just cat_ ->
                    let
                        board_ =
                            model.board
                                |> Dict.insert model.cat Free
                                |> Dict.insert cat_ (CatFacing NE)

                    in
                    { turn = if Search.isBoardEdge cat_
                             then
                                 Escaped
                             else
                                 Herder
                    , cat = cat_
                    , board = board_
                    }
    in
    ( model_, Cmd.none )


block : Model -> Coord -> ( Model, Cmd Msg )
block model coord =
    let
        board_ =
            Dict.insert coord Blocked model.board

        model_ =
            { model
                | turn = Cat
                , board = board_
            }
    in
    ( model_, Random.generate DirOrder directionOrder )
