module BoardList.View.BoardList exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Msg as Main exposing (..)
import Board.Model as Board
import BoardList.View.BoardItem exposing (boardItem)
import BoardList.Msg exposing (..)


boardList : String -> List Board.Model -> Html Main.Msg
boardList boards =
    section
        [ id "main"
        ]
        [ ul [ id "board-list" ]
            (List.map boardItem boards)
        ]
