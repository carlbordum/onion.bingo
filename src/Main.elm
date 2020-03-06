module Main exposing (..)



import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Random

import OnionData exposing (..)



-- MAIN

main =
  Browser.document
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL

type alias Quiz =
  { title : String
  , url : String
  , source : Source
  }

dummyPost = { title = "Loading", url = "https://onion.bingo/", source = TheOnion }
randomQuiz : Random.Generator Quiz
randomQuiz = Random.uniform dummyPost posts
randomCmd = Random.generate RandomEvent randomQuiz

type alias Model = { quiz : Quiz
                   , score : Int
                   }
init : () -> (Model, Cmd Msg)
init _ = ({quiz = dummyPost, score = 0}, randomCmd)



-- UPDATE

type Msg = Guess Source | RandomEvent Quiz

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Guess src ->
      case model.quiz.source == src of
        True ->
          ({model | score = model.score + 1}, randomCmd)
        False ->
          ({model | score = 0}, randomCmd)
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
