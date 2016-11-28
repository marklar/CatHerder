module Search exposing (..)

import Fifo exposing (..)
import Dict exposing (..)
-- import Debug exposing (log)

import Types exposing (..)

type alias Path = List Coord
type alias Frontier = Fifo Coord
type alias CameFrom = Dict Coord Coord


nowhere : Coord
nowhere = (-1,-1)

nextCoord : Board -> Coord -> List Direction -> Coord
nextCoord board coord dirs =
  let
    frontier = Fifo.fromList [coord]
    cameFrom = Dict.fromList [(coord, nowhere)]
  in
    case nextSpot board dirs frontier cameFrom of
      Nothing -> coord
      Just coord_ -> coord_

    
nextSpot : Board -> List Direction
         -> Frontier -> CameFrom
         -> Maybe Coord
nextSpot board dirs frontier cameFrom =
  case Fifo.remove frontier of

    -- We've run out of frontier spots to try.
    -- Never managed to find one at board's edge.
    (Nothing, _) ->
      Nothing

    -- Trying frontier spot...
    (Just curr, frontier_) ->
      if isBoardEdge curr then
        -- Found a board-edge spot. Return the spot that led us here.
        Just (pathStart curr cameFrom)
      else
        let
          -- Gather up frontier spot's explorable neighbors.
          unvisited c = not (Dict.member c cameFrom)
          ns = freeNeighbors board dirs curr
             |> List.filter unvisited
          -- Add them onto END of queue to explore (i.e. breadth-first).
          f_ = List.foldl Fifo.insert frontier_ ns
          -- Remember for each neighbor where we came from to get there.
          cf_ = List.foldl (\n -> Dict.insert n curr) cameFrom ns
        in
          nextSpot board dirs f_ cf_


isBoardEdge : Coord -> Bool
isBoardEdge (c,r) =
  c == 0 || c == maxCol ||
    r == 0 || r == maxRow


-- Always selects neighbors in the same order.
-- TODO: Pass in a Direction for it to start with.
freeNeighbors : Board -> List Direction -> Coord -> List Coord
freeNeighbors board dirs (c,r) =
  let
    diagWest = if r % 2 == 0 then c-1 else c
    diagEast = if r % 2 == 0 then c else c+1
    coordFor d =
      case d of
        NW -> (diagWest, r-1)
        NE -> (diagEast, r-1)
        SW -> (diagWest, r+1)
        SE -> (diagEast, r+1)
        W  -> (c-1, r)
        E  -> (c+1, r)
  in
    List.filter (isFree board) (List.map coordFor dirs)


isFree : Board -> Coord -> Bool
isFree board coord =
  case Dict.get coord board of
    Just Free -> True
    otherwise -> False
    

pathStart : Coord -> CameFrom -> Coord
pathStart coord cameFrom =
  case path coord cameFrom of
    f :: s :: _ -> s
    f :: _ -> f
    otherwise -> coord


path : Coord -> CameFrom -> Path
path coord cameFrom =
  let
    foo : Coord -> Path -> Path
    foo c acc =
      case Dict.get c cameFrom of
        Nothing -> acc
        Just c_ ->
          if c_ == nowhere then
            acc
          else
            foo c_ (c_ :: acc)
  in
    foo coord [coord]
