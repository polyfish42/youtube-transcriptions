module Main exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Events exposing (onInput)
import Parser exposing (parseTranscriptionXML)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { transrciptionXML : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "", Cmd.none )


type Msg
    = Change String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change transrciptionXML ->
            ( { model | transrciptionXML = transrciptionXML }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ textarea [ onInput Change ] []
        , viewParsedTranscript model.transrciptionXML
        ]


viewParsedTranscript : String -> Html Msg
viewParsedTranscript transcriptionXML =
    case parseTranscriptionXML transcriptionXML of
        Ok (_, _, result) ->
            p [] [text <| String.join "\n" <| List.map (\r -> (toString r.time) ++ r.content) result ] 

        Err (_, _, message) ->
            p [] [text <| String.join "" message ]
