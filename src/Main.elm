module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, img, p)
import Html.Attributes exposing (src)
import RemoteData exposing (WebData)
import Http
import Json.Decode exposing (..)

---- MODEL ----


type alias Model = {
    tokenAndUrl: WebData TokenAndUrl }


init : ( Model, Cmd Msg )
init =
    ( Model RemoteData.NotAsked, callFunction)



---- UPDATE ----


type Msg
    = NoOp
    | FunctionResponse (WebData TokenAndUrl)

type alias TokenAndUrl = {
    token: String,
    url: String }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FunctionResponse tokenAndUrl ->
            ( { model | tokenAndUrl = tokenAndUrl }, Cmd.none)
        _ ->
            ( model, Cmd.none )


callFunction: Cmd Msg
callFunction =
    Http.get { 
        expect = Http.expectJson (RemoteData.fromResult >> FunctionResponse) decodeTokenAndUrl,
        url = ".netlify/functions/call-api" 
    }

decodeTokenAndUrl : Decoder TokenAndUrl
decodeTokenAndUrl =
    Json.Decode.map2 TokenAndUrl
        (field "api-token" Json.Decode.string)
        (field "api-url" Json.Decode.string)

---- VIEW ----


view : Model -> Html Msg
view model =
    case model.tokenAndUrl of
        RemoteData.NotAsked -> 
            text "Initialising."

        RemoteData.Loading -> 
            text "Loading."
            
        RemoteData.Failure err -> 
            text "Error."

        RemoteData.Success tokenAndUrl -> 
            text ("Api Token: " ++ tokenAndUrl.token ++ ", Api Url: " ++ tokenAndUrl.url)



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
