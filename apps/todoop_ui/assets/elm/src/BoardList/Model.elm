module BoardList.Model exposing (..)

import Board.Model as Board


type alias Model =
    List Board.Model


model : Model
model =
    []
