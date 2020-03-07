module Main exposing (..)



import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Random

import Bulma.CDN exposing (..)
import Bulma.Modifiers exposing (..)
import Bulma.Modifiers.Typography exposing (textCentered)
import Bulma.Form exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Components exposing (..)
import Bulma.Columns as Columns exposing (..)
import Bulma.Layout exposing (..)

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
    [ stylesheet
    , hero { heroModifiers | color = Link, size = Large } []
      [ heroBody []
        [ container []
          [ title H1 [ textCentered ] [ Html.text model.quiz.title ]
          , fields Centered []
            [ controlButton { buttonModifiers | color = Warning, size = Large } [ onClick (Guess TheOnion) ] [] [ Html.text "TheOnion 🧅" ]
            , controlButton { buttonModifiers | color = Warning, size = Large } [ onClick (Guess NotTheOnion) ] [] [ Html.text "I think it's real 🤦" ]
            ]
          , fields Centered []
            [ title H1 [] [ Html.text (String.fromInt model.score) ]
            ]
          ]
        ]
      ]
    ]
  }
