module Board.View.Board exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Msg as Main exposing (..)
import Board.Model as Board
import Board.View.TaskItem exposing (taskItem)
import Board.Msg exposing (..)


board : String -> Board.Model -> Html Main.Msg
board visibility board =
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
            List.all .completed board.tasks

        cssVisibility =
            if List.isEmpty board.tasks then
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
                , onClick (MsgForBoard <| CheckAll (not allCompleted))
                ]
                []
            , label [ for "toggle-all" ]
                [ text "Mark all as complete" ]
            , ul [ id "task-list" ]
                (List.map taskItem (List.filter isVisible board.tasks))
            ]
