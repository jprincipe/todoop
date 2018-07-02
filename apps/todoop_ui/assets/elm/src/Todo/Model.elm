module Todo.Model exposing (..)


type alias Model =
    { title : String
    , completed : Bool
    , editing : Bool
    , id : Int
    }


newTodo : Int -> String -> Model
newTodo id title =
    { title = title
    , completed = False
    , editing = False
    , id = id
    }


model : Model
model =
    newTodo 1 ""
