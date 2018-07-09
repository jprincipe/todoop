module Msg exposing (..)

import Control.Msg as Control
import Task.Msg as Task
import Board.Msg as Board


type Msg
    = NoOp
    | MsgForTaskEntry Task.Msg
    | MsgForBoard Board.Msg
    | MsgForControl Control.Msg
