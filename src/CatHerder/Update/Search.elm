module CatHerder.Update.Search exposing ( nextCoord, isBoardEdge )

-- import Debug exposing (log)
import Dict
import Fifo

import CatHerder.Constants as Constants
import CatHerder.Types exposing (Board, Coord, Direction(..), Spot(..))


type alias Path =
    List Coord


type alias Frontier =
    Fifo.Fifo Coord


type alias CameFrom =
    Dict.Dict Coord Coord


nowhere : Coord
nowhere =
    ( -1, -1 )


nextCoord : Board -> Coord -> List Direction -> Maybe Coord
nextCoord board coord dirs =
    let
        frontier =
            Fifo.fromList [ coord ]

        cameFrom =
            Dict.fromList [ ( coord, nowhere ) ]
    in
    nextCoord_ board dirs frontier cameFrom


nextCoord_ : Board
           -> List Direction
           -> Frontier
           -> CameFrom
           -> Maybe Coord
nextCoord_ board dirs frontier cameFrom =
    case Fifo.remove frontier of
        -- We've run out of frontier spots to try.
        -- Never managed to find one at board's edge.
        ( Nothing, _ ) ->
            Nothing

        -- Trying frontier spot...
        ( Just curr, frontier_ ) ->
            if isBoardEdge curr then
                -- Found a board-edge spot. Return the spot that led us here.
                Just (pathStart curr cameFrom)

            else
                let
                    -- Gather up frontier spot's explorable neighbors.
                    unvisited c =
                        not (Dict.member c cameFrom)

                    explorables =
                        freeNeighbors board dirs curr
                            |> List.filter unvisited

                    -- Add them onto END of queue to explore (i.e. breadth-first).
                    newFrontier =
                        List.foldl Fifo.insert frontier_ explorables

                    -- Remember for each neighbor where we came from to get there.
                    newCameFrom =
                        List.foldl (\n -> Dict.insert n curr) cameFrom explorables
                in
                nextCoord_ board dirs newFrontier newCameFrom


isBoardEdge : Coord -> Bool
isBoardEdge ( c, r ) =
    (c == 0)
        || (c == Constants.maxCol)
        || (r == 0)
        || (r == Constants.maxRow)



---------------
-- Always selects neighbors in the same order.
-- TODO: Pass in a Direction for it to start with.


freeNeighbors : Board -> List Direction -> Coord -> List Coord
freeNeighbors board dirs ( c, r ) =
    let
        diagWest =
            if modBy 2 r == 0 then
                c - 1

            else
                c

        diagEast =
            if modBy 2 r == 0 then
                c

            else
                c + 1

        coordFor d =
            case d of
                NW ->
                    ( diagWest, r - 1 )

                NE ->
                    ( diagEast, r - 1 )

                SW ->
                    ( diagWest, r + 1 )

                SE ->
                    ( diagEast, r + 1 )

                W ->
                    ( c - 1, r )

                E ->
                    ( c + 1, r )
    in
    List.filter (isFree board) (List.map coordFor dirs)


isFree : Board -> Coord -> Bool
isFree board coord =
    case Dict.get coord board of
        Just Free ->
            True

        otherwise ->
            False



---------------


pathStart : Coord -> CameFrom -> Coord
pathStart coord cameFrom =
    case path coord cameFrom of
        fst :: snd :: _ ->
            snd

        fst :: _ ->
            fst

        otherwise ->
            coord


path : Coord -> CameFrom -> Path
path coord cameFrom =
    let
        foo : Coord -> Path -> Path
        foo c acc =
            case Dict.get c cameFrom of
                Nothing ->
                    acc

                Just c_ ->
                    if c_ == nowhere then
                        acc

                    else
                        foo c_ (c_ :: acc)
    in
    foo coord [ coord ]
