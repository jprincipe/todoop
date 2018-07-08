module TaskList.View.TaskList exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Msg as Main exposing (..)
import Task.Model as Task
import TaskList.View.TaskItem exposing (taskItem)
import TaskList.Msg exposing (..)


taskList : String -> List Task.Model -> Html Main.Msg
taskList visibility tasks =
    let
        isVisible task =
            case visibility of
                "Completed" ->
                    task.completed

                "Active" ->
                    not task.completed

                _ ->
                    True

        allCompleted =
            List.all .completed tasks

        cssVisibility =
            if List.isEmpty tasks then
                "hidden"
            else
                "visible"
    in
        section
            [ id "main"
            , style [ ( "visibility", cssVisibility ) ]
            ]
            [ input
                [ id "toggle-all"
                , type_ "checkbox"
                , name "toggle"
                , checked allCompleted
                , onClick (MsgForTaskList <| CheckAll (not allCompleted))
                ]
                []
            , label [ for "toggle-all" ]
                [ text "Mark all as complete" ]
            , ul [ id "task-list" ]
                (List.map taskItem (List.filter isVisible tasks))
            ]
