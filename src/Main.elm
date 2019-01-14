module Main exposing (main)

import Browser

import CatHerder.Init   as Init
import CatHerder.Update as Update
import CatHerder.View   as View


main =
    Browser.element
        { init = Init.init
        , update = Update.update
        , subscriptions = always Sub.none
        , view = View.view
        }
