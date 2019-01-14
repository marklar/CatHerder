module View exposing (view)

import Constants
import Dict
import Html
import Html.Events as Html
import Svg
import Svg.Attributes as Svg
import Types exposing (Msg(..), Model, Coord, Spot(..), Pt, Turn(..))
-- import ViewCircle as V
import ViewHex as V


view : Model -> Html.Html Msg
view model =
    let
        btn =
            Html.button [ Html.onClick Reset ] [ Html.text "reset" ]

        btnList =
            case model.turn of
                Escaped ->
                    [ btn ]

                Trapped ->
                    [ btn ]

                _ ->
                    []
    in
    Html.div []
        [ Html.text (showTurn model.turn)
        , Html.div []
            [ Svg.svg
                  [ Svg.version "1.1"
                  , Svg.x "0"
                  , Svg.y "0"
                  , Svg.viewBox "0 0 120 105"
                  ]
                  (grid model)
            ]
        , Html.div [] btnList
        ]


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
        ( color, mbMsg ) =
            case spot of
                Free ->
                    ( Constants.bluish
                    , case turn of
                        Herder ->
                            Just (Clicked coord)

                        otherwise ->
                            Nothing
                    )

                Blocked ->
                    ( Constants.orangish, Nothing )

                CatFacing _ ->
                    ( Constants.grayish, Nothing )
    in
    V.spot color Constants.spotRadius (getCenter coord) mbMsg


-- GET CENTER

getCenter : Coord -> Pt
getCenter ( col, row ) =
    ( getX ( col, row ), getY row )


getX : Coord -> Float
getX ( col, row ) =
    let
        xMargin =
            if modBy 2 row == 0 then
                0
            else
                Constants.spotRadius
    in
    xMargin
        + (toFloat col * 2.1 * Constants.spotRadius)
        + Constants.spotRadius


getY : Int -> Float
getY row =
    toFloat row * Constants.spotHeight
        + Constants.spotRadius
