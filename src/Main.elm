module Main exposing (..)



import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Random



-- MAIN

main =
  Browser.document
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL

type Source = TheOnion | NotTheOnion
type alias Quiz =
  { title : String
  , source : Source
  }

p1 = { title = "O1", source = TheOnion }
posts = [ { title = "O2", source = TheOnion }
        , { title = "N1", source = NotTheOnion }
        , { title = "N2", source = NotTheOnion }
        ]

randomQuiz : Random.Generator Quiz
randomQuiz = Random.uniform p1 posts

type alias Model = Quiz
init : () -> (Model, Cmd Msg)
init _ = (p1, Cmd.none)



-- UPDATE

type Msg = GuessOnion | GuessNotOnion | RandomEvent Quiz

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GuessOnion ->
      (model, Random.generate RandomEvent randomQuiz)

    GuessNotOnion ->
      (model, Random.generate RandomEvent randomQuiz)

    RandomEvent q ->
      (q, Cmd.none)



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none



-- VIEW

view : Model -> Browser.Document Msg
view model =
  { title = "onion.bingo"
  , body =
    [ div []
      [ div [] [ text model.title ]
      , button [ onClick GuessOnion ] [ text "TheOnion!" ]
      , button [ onClick GuessNotOnion ] [ text "NotTheOnion!" ]
      ]
      ]
  }
