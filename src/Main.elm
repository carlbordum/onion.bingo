module Main exposing (..)

import Browser
import Bulma.CDN exposing (..)
import Bulma.Columns as Columns exposing (..)
import Bulma.Components exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Modifiers exposing (..)
import Bulma.Modifiers.Typography exposing (textCentered)
import Html exposing (Attribute, Html, a, button, div, p, strong, text)
import Html.Attributes exposing (href, rel)
import Html.Events exposing (onClick)
import OnionData exposing (..)
import Random



-- MAIN


main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }



-- MODEL


type alias Quiz =
    { title : String
    , url : String
    , source : Source
    }


type alias Model =
    { quiz : Quiz
    , score : Int
    , rulesRead : Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { quiz = dummyPost, score = 0, rulesRead = False }
    , randomCmd
    )


dummyPost =
    { title = "Loading...", url = "https://onion.bingo/", source = TheOnion }


randomCmd =
    Random.uniform dummyPost posts
        |> Random.generate RandomEvent



-- UPDATE


type Msg
    = Guess Source
    | RandomEvent Quiz
    | RulesRead


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Guess src ->
            case model.quiz.source == src of
                True ->
                    ( { model | score = model.score + 1 }
                    , randomCmd
                    )

                False ->
                    ( { model | score = 0 }
                    , randomCmd
                    )

        RandomEvent q ->
            ( { model | quiz = q }
            , Cmd.none
            )

        RulesRead ->
            ( { model | rulesRead = True }
            , Cmd.none
            )



{- VIEW -}


stylesheetUrl : String
stylesheetUrl =
    "https://jenil.github.io/bulmaswatch/darkly/bulmaswatch.min.css"


stylesheetLink : Html msg
stylesheetLink =
    Html.node "link"
        [ Html.Attributes.rel "stylesheet"
        , Html.Attributes.href stylesheetUrl
        ]
        []


centeredTitle : String -> Html Msg
centeredTitle titleText =
    title
        H2
        [ textCentered ]
        [ Html.text titleText ]


answerButton : Source -> String -> Html Msg
answerButton srcGuess buttonText =
    -- make a bulma button for answering the current quiz
    controlButton
        { buttonModifiers | color = Warning, size = Large }
        [ onClick (Guess srcGuess) ]
        []
        [ Html.text buttonText ]


heroContainer : List (Html Msg) -> Html Msg
heroContainer htmls =
    hero { heroModifiers | color = Primary, size = Large }
        []
        [ heroBody []
            [ container []
                htmls
            ]
        ]


bingoFooter =
    footer []
        [ container []
            [ content Standard
                [ textCentered ]
                [ p []
                    [ strong [] [ text "onion.bingo" ]
                    , text " is "
                    , a [ href "https://www.fsf.org/about/what-is-free-software" ] [ text "free software" ]
                    , text ". You can "
                    , a [ href "https://github.com/carlbordum/onion.bingo" ] [ text "read the source" ]
                    , text ". Hope you have fun :-)"
                    ]
                ]
            ]
        ]


ruleNotification rulesRead =
    case rulesRead of
        True ->
            Html.text ""

        False ->
            columns columnsModifiers
                []
                [ column { columnModifiers | offset = Auto }
                    []
                    [ notificationWithDelete
                        Info
                        []
                        RulesRead
                        [ text "Welcome to onion.bingo! The game is simple: try to guess correctly as many times in row as possible. What are you guessing? Published articles. Half of them satirical."
                        ]
                    ]
                ]


view : Model -> Browser.Document Msg
view model =
    { title = "onion.bingo \u{1F9C5}\u{1F926}"
    , body =
        [ stylesheetLink
        , heroContainer
            [ ruleNotification model.rulesRead
            , centeredTitle model.quiz.title
            , fields Centered
                []
                [ answerButton TheOnion "TheOnion \u{1F9C5}"
                , answerButton NotTheOnion "I think it's real \u{1F926}"
                ]
            , fields Centered
                []
                [ model.score |> String.fromInt |> centeredTitle ]
            ]
        , bingoFooter
        ]
    }
