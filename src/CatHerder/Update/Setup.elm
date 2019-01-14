module CatHerder.Update.Setup exposing (setupBlocks)

import Dict
import Set

import CatHerder.Constants as Constants
import CatHerder.Init as Init
import CatHerder.Types exposing (Msg(..), Model, Coord, Spot(..), Turn(..))


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
