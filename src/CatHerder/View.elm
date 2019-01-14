module CatHerder.View exposing (view)

import Dict
import Html
import Html.Events as Html
import Svg
import Svg.Attributes as Svg

import CatHerder.Constants as Constants
import CatHerder.Types exposing (Msg(..), Model, Coord, Spot(..), Pt, Turn(..))
-- import CatHerder.View.Circle as Spot
import CatHerder.View.Hex as Spot


view : Model -> Html.Html Msg
view model =
    Html.div []
        ( [ Html.text (showTurn model.turn)
          , Svg.svg [ Svg.version "1.1"
                    , Svg.x "0"
                    , Svg.y "0"
                    , Svg.viewBox viewBoxDimStr
                    ]
              (grid model)
          , buttonOrEmpty model.turn
          ]
        )


buttonOrEmpty : Turn -> Html.Html Msg
buttonOrEmpty turn =
    let
        btn =
            Html.button [ Html.onClick Reset ] [ Html.text "Try Again" ]
    in
        case turn of
            Escaped ->
                btn

            Trapped ->
                btn

            _ ->
                memptyHtml


memptyHtml : Html.Html a
memptyHtml =
    Html.text ""


showTurn : Turn -> String
showTurn turn =
    case turn of
        Cat ->
            "Cat's turn."

        Herder ->
            "Your turn."

        Escaped ->
            "Aw, bummer! The cat escaped."

        Trapped ->
            "Congrats! You trapped the cat."


grid : Model -> List (Svg.Svg Msg)
grid model =
    model.board
        |> Dict.toList
        |> List.map (oneSpot model.turn)


oneSpot : Turn -> ( Coord, Spot ) -> Svg.Svg Msg
oneSpot turn ( coord, spot ) =
    let
        color =
            case spot of
                Free ->
                    Constants.bluish

                Blocked ->
                    Constants.orangish

                CatFacing _ ->
                    Constants.grayish

        mbMsg =
            if turn == Herder && spot == Free then
                Just (Clicked coord)

            else
                Nothing
    in
    Spot.spot color Constants.spotRadius (getCenter coord) mbMsg


-- VIEWBOX DIMENSIONS

viewBoxDimStr =
    let
        ( w, h ) =
            viewBoxDimensions
    in
    "0 0 " ++ String.fromFloat w ++ " " ++ String.fromFloat h


viewBoxDimensions : ( Float, Float )
viewBoxDimensions =
    let
        maxBoardWidth =
            getCenterX ( Constants.maxCol, 1 )
                + Constants.spotRadius

        maxBoardHeight =
            getCenterY Constants.maxRow
                + Constants.spotRadius
    in
    ( maxBoardWidth, maxBoardHeight )


-- GET CENTER

getCenter : Coord -> Pt
getCenter ( col, row ) =
    ( getCenterX ( col, row ), getCenterY row )


getCenterX : Coord -> Float
getCenterX ( col, row ) =
    let
        xMargin =
            if modBy 2 row == 0 then
                0

            else
                Constants.spotRadius
    in
    xMargin
        + (toFloat col * (Constants.spotRadius * 2.1))
        + Constants.spotRadius


getCenterY : Int -> Float
getCenterY row =
    toFloat row * Constants.spotHeight
        + Constants.spotRadius
