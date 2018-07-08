module Control.View.Controls exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Control.Msg exposing (..)
import Msg as Main exposing (..)
import Task.Model as Task
import TaskList.Msg exposing (..)


controls : String -> List Task.Model -> Html Main.Msg
controls visibility tasks =
    let
        tasksCompleted =
            List.length (List.filter .completed tasks)

        tasksLeft =
            List.length tasks - tasksCompleted

        item_ =
            if tasksLeft == 1 then
                " item"
            else
                " items"
    in
        footer
            [ id "footer"
            , hidden (List.isEmpty tasks)
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
                , onClick (MsgForTaskList DeleteCompleted)
                ]
                [ text ("Clear completed (" ++ toString tasksCompleted ++ ")") ]
            ]


visibilitySwap : String -> String -> String -> Html Main.Msg
visibilitySwap uri visibility actualVisibility =
    li [ onClick (MsgForControl <| ChangeVisibility visibility) ]
        [ a [ href uri, classList [ ( "selected", visibility == actualVisibility ) ] ] [ text visibility ] ]
