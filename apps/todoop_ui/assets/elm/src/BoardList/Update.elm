module BoardList.Update exposing (..)

import Msg as Main exposing (..)
import String
import Board.Model exposing (newBoard)
import Board.Msg as Board exposing (..)
import Board.Update as UpdateBoard
import BoardList.Model exposing (Model)
import BoardList.Msg as BoardList exposing (..)


update : Main.Msg -> Model -> Model
update msgFor boardList =
    case msgFor of
        MsgForBoardList msg ->
            updateBoardList msg boardList

        _ ->
            boardList


updateBoardList : BoardList.Msg -> Model -> Model
updateBoardList msg boardList =
    case msg of
        Add id name ->
            if String.isEmpty name then
                boardList
            else
                boardList ++ [ newBoard id name ]

        Delete id ->
            List.filter (\t -> t.id /= id) boardList

        MsgForBoard id msg ->
            updateBoard id msg boardList


updateBoard : Int -> Board.Msg -> Model -> Model
updateBoard id msg boardList =
    let
        updateBoard board =
            if board.id == id then
                UpdateBoard.updateBoard msg board
            else
                board
    in
        List.map updateBoard boardList


type alias FocusPort a =
    String -> Cmd a


updateCmd : FocusPort a -> Main.Msg -> Cmd a
updateCmd focus msg =
    case msg of
        MsgForBoardList (MsgForBoard id (Editing _)) ->
            focus ("#board-" ++ toString id)

        _ ->
            Cmd.none
