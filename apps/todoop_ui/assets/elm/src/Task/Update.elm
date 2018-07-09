module Task.Update exposing (..)

import Msg as Main exposing (..)
import Task.Model exposing (Model, newTask)
import Task.Msg as Task exposing (..)
import Board.Msg exposing (..)


update : Main.Msg -> Model -> Model
update msgFor task =
    case msgFor of
        MsgForTaskEntry msg ->
            updateTask msg task

        MsgForBoard (Add id _) ->
            newTask (id + 1) ""

        _ ->
            task


updateTask : Task.Msg -> Model -> Model
updateTask msg model =
    case msg of
        Check isCompleted ->
            { model | completed = isCompleted }

        Editing isEditing ->
            { model | editing = isEditing }

        Update title ->
            { model | title = title }
