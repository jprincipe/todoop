module TaskList.Update exposing (..)

import Msg as Main exposing (..)
import String
import Task.Model exposing (newTask)
import Task.Msg as Task exposing (..)
import Task.Update as UpdateTask
import TaskList.Model exposing (Model)
import TaskList.Msg as TaskList exposing (..)


update : Main.Msg -> Model -> Model
update msgFor taskList =
    case msgFor of
        MsgForTaskList msg ->
            updateTaskList msg taskList

        _ ->
            taskList


updateTaskList : TaskList.Msg -> Model -> Model
updateTaskList msg taskList =
    case msg of
        Add id title ->
            if String.isEmpty title then
                taskList
            else
                taskList ++ [ newTask id title ]

        Delete id ->
            List.filter (\t -> t.id /= id) taskList

        DeleteCompleted ->
            List.filter (not << .completed) taskList

        CheckAll isCompleted ->
            let
                updateTask t =
                    UpdateTask.updateTask (Check isCompleted) t
            in
                List.map updateTask taskList

        MsgForTask id msg ->
            updateTask id msg taskList


updateTask : Int -> Task.Msg -> Model -> Model
updateTask id msg taskList =
    let
        updateTask task =
            if task.id == id then
                UpdateTask.updateTask msg task
            else
                task
    in
        List.map updateTask taskList


type alias FocusPort a =
    String -> Cmd a


updateCmd : FocusPort a -> Main.Msg -> Cmd a
updateCmd focus msg =
    case msg of
        MsgForTaskList (MsgForTask id (Editing _)) ->
            focus ("#task-" ++ toString id)

        _ ->
            Cmd.none
