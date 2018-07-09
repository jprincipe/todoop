module Board.Msg exposing (..)

import Task.Msg as Task


type Msg
    = Add Int String
    | Delete Int
    | DeleteCompleted
    | CheckAll Bool
    | MsgForTask Int Task.Msg
