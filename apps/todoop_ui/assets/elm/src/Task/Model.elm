module Task.Model exposing (..)


type alias Model =
    { title : String
    , description : String
    , completed : Bool
    , editing : Bool
    , id : Int
    }


newTask : Int -> String -> Model
newTask id title =
    { title = title
    , description = ""
    , completed = False
    , editing = False
    , id = id
    }


model : Model
model =
    newTask 1 ""
