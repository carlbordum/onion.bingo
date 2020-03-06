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

type alias Model = { quiz : Quiz
                   , score : Int
                   }
init : () -> (Model, Cmd Msg)
init _ = ({quiz = p1, score = 0}, Cmd.none)



-- UPDATE

type Msg = Guess Source | RandomEvent Quiz

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Guess src ->
      case model.quiz.source == src of
        True ->
          ({model | score = model.score + 1}, Random.generate RandomEvent randomQuiz)
        False ->
          ({model | score = 0}, Random.generate RandomEvent randomQuiz)
    RandomEvent q ->
      ({model | quiz = q}, Cmd.none)



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none



-- VIEW

view : Model -> Browser.Document Msg
view model =
  { title = "onion.bingo"
  , body =
    [ div []
      [ div [] [ text model.quiz.title ]
      , div [] [ text (String.fromInt model.score) ]
      , button [ onClick (Guess TheOnion) ] [ text "TheOnion!" ]
      , button [ onClick (Guess NotTheOnion) ] [ text "NotTheOnion!" ]
      ]
      ]
  }
