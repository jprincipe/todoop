module Msg exposing (..)

import Control.Msg as Control
import Task.Msg as Task
import TaskList.Msg as TaskList


type Msg
    = NoOp
    | MsgForTaskEntry Task.Msg
    | MsgForTaskList TaskList.Msg
    | MsgForControl Control.Msg
