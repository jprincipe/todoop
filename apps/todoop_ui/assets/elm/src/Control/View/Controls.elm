module Control.View.Controls exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Control.Msg exposing (..)
import Msg as Main exposing (..)
import Board.Model as Board exposing (..)
import Board.Msg exposing (..)


controls : String -> Board.Model -> Html Main.Msg
controls visibility board =
    let
        tasksCompleted =
            List.length (List.filter .completed board.tasks)

        tasksLeft =
            List.length board.tasks - tasksCompleted

        item_ =
            if tasksLeft == 1 then
                " item"
            else
                " items"
    in
        footer
            [ id "footer"
            , hidden (List.isEmpty board.tasks)
            ]
            [ span [ id "task-count" ]
                [ strong [] [ text (toString tasksLeft) ]
                , text (item_ ++ " left")
                ]
            , ul [ id "filters" ]
                [ visibilitySwap "#/" "All" visibility
                , text " "
                , visibilitySwap "#/active" "Active" visibility
                , text " "
                , visibilitySwap "#/completed" "Completed" visibility
                ]
            , button
                [ class "clear-completed"
                , id "clear-completed"
                , hidden (tasksCompleted == 0)
                , onClick (MsgForBoard DeleteCompleted)
                ]
                [ text ("Clear completed (" ++ toString tasksCompleted ++ ")") ]
            ]


visibilitySwap : String -> String -> String -> Html Main.Msg
visibilitySwap uri visibility actualVisibility =
    li [ onClick (MsgForControl <| ChangeVisibility visibility) ]
        [ a [ href uri, classList [ ( "selected", visibility == actualVisibility ) ] ] [ text visibility ] ]
