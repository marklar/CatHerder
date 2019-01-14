module CatHerder.Update exposing (update)

import Dict
import Process
import Random
import Task

import CatHerder.Constants as Constants
import CatHerder.Update.Generators exposing (directionOrder)
import CatHerder.Init as Init
import CatHerder.Update.Search as Search
import CatHerder.Update.Setup as Setup
import CatHerder.Types exposing (Msg(..), Model, Coord, Spot(..), Turn(..), Direction(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            Init.init ()

        SetupCoords coords ->
            Setup.setupBlocks model coords

        Clicked coord ->
            block model coord

        CatDelay ->
            ( model, Random.generate DirOrder directionOrder )

        DirOrder dirs ->
            moveCat model dirs


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
                    { turn = if Search.isBoardEdge cat_ then
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
    ( model_, delay Constants.catDelayMillis CatDelay )


delay : Float -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.perform (\_ -> msg)
