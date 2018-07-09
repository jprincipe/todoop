module BoardList.Msg exposing (..)

import Board.Msg as Board


type Msg
    = Add Int String
    | Delete Int
    | MsgForBoard Int Board.Msg
