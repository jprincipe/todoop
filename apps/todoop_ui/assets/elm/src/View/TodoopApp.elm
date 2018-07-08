module View.TodoopApp exposing (..)

import Control.View.Controls as ControlsView
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy, lazy2)
import Model exposing (Model)
import Msg exposing (..)
import Task.View.TaskEntry as TaskEntryView
import TaskList.View.TaskList as TaskListView
import View.InfoFooter exposing (infoFooter)


view : Model -> Html Msg
view model =
    let
        taskList =
            model.taskList

        taskEntry =
            model.taskEntry

        control =
            model.control
    in
        div
            [ class "todoop-wrapper"
            , style [ ( "visibility", "hidden" ) ]
            ]
            [ section [ id "todoop-app" ]
                [ lazy TaskEntryView.taskEntry taskEntry
                , lazy2 TaskListView.taskList control.visibility taskList
                , lazy2 ControlsView.controls control.visibility taskList
                ]
            , infoFooter
            ]
