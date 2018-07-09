module Board.Model exposing (..)

import Task.Model as Task


type alias Model =
    { name : String
    , description : String
    , id : Int
    , tasks : List Task.Model
    }


newBoard : Int -> String -> Model
newBoard id name =
    { name = name
    , description = ""
    , id = id
    , tasks = []
    }


model : Model
model =
    newBoard 1 ""
