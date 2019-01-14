module CatHerder.Update exposing (update)

import Dict
import Process
import Random
import Set
import Task
import Time

import CatHerder.Constants as Constants
import CatHerder.Update.Generators exposing (directionOrder)
import CatHerder.Init as Init
import CatHerder.Update.Search as Search
import CatHerder.Types exposing (Msg(..), Model, Coord, Spot(..), Turn(..), Direction(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            Init.init ()

        SetupCoords coords ->
            setupBlocks model coords

        Clicked coord ->
            block model coord

        CatDelay ->
            ( model, Random.generate DirOrder directionOrder )

        DirOrder dirs ->
            moveCat model dirs


-- | If coords contains Init.initCatCoord,
-- then replace it with another Coord.
setupBlocks : Model -> List Coord -> ( Model, Cmd Msg )
setupBlocks model blockCoords =
    let
        board_ =
            List.foldl
                (\c -> Dict.insert c Blocked)
                model.board
                blockCoords

        model_ =
            { model
                | turn = Herder
                , board = board_
            }
    in
    if not (areBlocksOkay blockCoords) then
        Init.init ()
    else
        ( model_, Cmd.none )


areBlocksOkay : List Coord -> Bool
areBlocksOkay blockCoords =
    let
        areUniq =
            List.length (uniq blockCoords)
                == Constants.numInitBlocks

        containCat =
            List.member Init.initCatCoord blockCoords
    in
        areUniq && not containCat


uniq : List comparable -> List comparable
uniq = Set.toList << Set.fromList


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
