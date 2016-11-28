module Update exposing (..)

import Dict exposing (..)
import Random exposing (..)

import Direction exposing (directionOrder)
import Types exposing (..)
import Search exposing (..)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Clicked coord ->
      block model coord
    DirOrder dirs ->
      moveCat model dirs

------------

moveCat : Model -> List Direction -> (Model, Cmd Msg)
moveCat model dirs =
  let
    cat_ = Search.nextCoord model.board model.cat dirs
    -- TODO: clamp 0 maxCols | maxRows
    model_ =
      { turn = Herder
      , cat = cat_
      , board = moveCatFromTo model.board model.cat cat_
      }
  in
    (model_, Cmd.none)


moveCatFromTo : Board -> Coord -> Coord -> Board
moveCatFromTo board from to =
  board
    |> Dict.insert to (Facing NE)  -- FIXME
    |> Dict.insert from Free


block : Model -> Coord -> (Model, Cmd Msg)
block model coord =
  let
    board_ = model.board |> Dict.insert coord Blocked
    model_ =
      { turn = Cat
      , cat = model.cat
      , board = board_
      }
  in
    (model_, Random.generate DirOrder directionOrder)
