module View.TodoopApp exposing (..)

import Control.View.Controls as ControlsView
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy, lazy2)
import Model exposing (Model)
import Msg exposing (..)
import Task.View.TaskEntry as TaskEntryView
import Board.View.Board as BoardView
import View.InfoFooter exposing (infoFooter)


view : Model -> Html Msg
view model =
    let
        board =
            model.board

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
                , lazy2 BoardView.board control.visibility board
                , lazy2 ControlsView.controls control.visibility board
                ]
            , infoFooter
            ]
