module View.InfoFooter exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Msg exposing (Msg)


infoFooter : Html Msg
infoFooter =
    footer [ id "info" ]
        [ p [] [ text "Double-click to edit a task" ]
        ]
