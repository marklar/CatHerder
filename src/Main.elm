module Main exposing (main)

import Browser
import Init
import Update
import View


main =
    Browser.element
        { init = Init.init
        , update = Update.update
        , subscriptions = always Sub.none
        , view = View.view
        }
