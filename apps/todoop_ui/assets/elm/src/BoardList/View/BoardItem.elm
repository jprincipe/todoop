module BoardList.View.BoardItem exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import Msg as Main exposing (..)
import Board.Model as Board
import Board.Msg exposing (..)
import Board.View.Events exposing (onEnter)
import BoardList.Msg exposing (..)


boardItem : Board.Model -> Html Main.Msg
boardItem board =
    li [ classList [ ( "editing", board.editing ) ] ]
        [ div [ class "view" ]
            [ label [ onDoubleClick (MsgForBoardList <| MsgForBoard board.id <| Editing True) ]
                [ text board.name ]
            , button
                [ class "destroy"
                , onClick (MsgForBoardList <| Delete board.id)
                ]
                []
            ]
        , input
            [ class "edit"
            , value board.name
            , name "name"
            , id ("board-" ++ toString board.id)
            , on "input" (Json.map (MsgForBoardList << MsgForBoard board.id << Update) targetValue)
            , onBlur (MsgForBoardList <| MsgForBoard board.id <| Editing False)
            , onEnter NoOp (MsgForBoardList <| MsgForBoard board.id <| Editing False)
            ]
            []
        ]
