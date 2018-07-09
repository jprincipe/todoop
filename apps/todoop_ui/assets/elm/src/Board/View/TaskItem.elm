module Board.View.TaskItem exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import Msg as Main exposing (..)
import Task.Model as Task
import Task.Msg exposing (..)
import Task.View.Events exposing (onEnter)
import Board.Msg exposing (..)


taskItem : Task.Model -> Html Main.Msg
taskItem task =
    li [ classList [ ( "completed", task.completed ), ( "editing", task.editing ) ] ]
        [ div [ class "view" ]
            [ input
                [ class "toggle"
                , type_ "checkbox"
                , checked task.completed
                , onClick (MsgForBoard <| MsgForTask task.id <| Check (not task.completed))
                ]
                []
            , label [ onDoubleClick (MsgForBoard <| MsgForTask task.id <| Editing True) ]
                [ text task.title ]
            , button
                [ class "destroy"
                , onClick (MsgForBoard <| Delete task.id)
                ]
                []
            ]
        , input
            [ class "edit"
            , value task.title
            , name "title"
            , id ("task-" ++ toString task.id)
            , on "input" (Json.map (MsgForBoard << MsgForTask task.id << Update) targetValue)
            , onBlur (MsgForBoard <| MsgForTask task.id <| Editing False)
            , onEnter NoOp (MsgForBoard <| MsgForTask task.id <| Editing False)
            ]
            []
        ]
