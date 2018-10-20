module Main exposing (Model, Msg(..), getRandomGif, init, main, messageDecoder, subscriptions, toGiphyUrl, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)
import Url.Builder as Url



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { topic : String
    , url : String
    , errorMessage : Maybe String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "cat" "waiting.gif" (Just "Nothing")
    , getRandomGif "cat"
    )



-- UPDATE


type Msg
    = MorePlease
    | NewGif (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( model
            , getRandomGif model.topic
            )

        NewGif result ->
            case result of
                Ok newUrl ->
                    ( { model | url = newUrl }
                    , Cmd.none
                    )

                Err httpError ->
                    ( { model | errorMessage = Just (createErrorMessage httpError) }
                    , Cmd.none
                    )


createErrorMessage : Http.Error -> String
createErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "It appears you don't have an Internet connection right now."

        Http.BadStatus response ->
            response.status.message

        Http.BadPayload message response ->
            message



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text model.topic ]
        , button [ onClick MorePlease ] [ text "More Please!" ]
        , br [] []
        , h2 [] [ text model.url ]
        , viewTopicOrError model
        ]


viewTopicOrError : Model -> Html Msg
viewTopicOrError model =
    case model.errorMessage of
        Just message ->
            viewError message

        Nothing ->
            viewTopic model.topic


viewError : String -> Html Msg
viewError errorMessage =
    let
        errorHeading =
            "Couldn't fetch at this time."
    in
    div []
        [ h3 [] [ text errorHeading ]
        , text ("Error: " ++ errorMessage)
        ]


viewTopic : String -> Html Msg
viewTopic topic =
    div []
        [ h3 [] [ text topic ] ]



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    Http.send NewGif (Http.get (toGiphyUrl topic) messageDecoder)


toGiphyUrl : String -> String
toGiphyUrl topic =
    Url.crossOrigin "http://localhost:3010" [] []


messageDecoder : Decoder String
messageDecoder =
    field "message" string
