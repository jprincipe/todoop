module Board.Update exposing (..)

import Msg as Main exposing (..)
import String
import Task.Model as Task exposing (newTask)
import Task.Msg as Task exposing (..)
import Task.Update as UpdateTask
import Board.Model exposing (Model)
import Board.Msg as Board exposing (..)


update : Main.Msg -> Model -> Model
update msgFor board =
    case msgFor of
        MsgForBoard msg ->
            updateBoard msg board

        _ ->
            board


updateBoard : Board.Msg -> Model -> Model
updateBoard msg board =
    case msg of
        Add id title ->
            if String.isEmpty title then
                board
            else
                { board | tasks = (board.tasks ++ [ newTask id title ]) }

        Delete id ->
            { board | tasks = (List.filter (\t -> t.id /= id) board.tasks) }

        DeleteCompleted ->
            { board | tasks = (List.filter (not << .completed) board.tasks) }

        CheckAll isCompleted ->
            let
                updateTask t =
                    UpdateTask.updateTask (Check isCompleted) t
            in
                { board | tasks = (List.map updateTask board.tasks) }

        MsgForTask id msg ->
            { board | tasks = (updateTask id msg board.tasks) }


updateTask : Int -> Task.Msg -> List Task.Model -> List Task.Model
updateTask id msg tasks =
    let
        updateTask task =
            if task.id == id then
                UpdateTask.updateTask msg task
            else
                task
    in
        List.map updateTask tasks


type alias FocusPort a =
    String -> Cmd a


updateCmd : FocusPort a -> Main.Msg -> Cmd a
updateCmd focus msg =
    case msg of
        MsgForBoard (MsgForTask id (Editing _)) ->
            focus ("#task-" ++ toString id)

        _ ->
            Cmd.none
