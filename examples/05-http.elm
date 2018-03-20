module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


main =
    Html.program
        { init = init "cats"
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { topic : String
    , gifUrl : String
    , isErroneous : Bool
    , errMsg : String
    }


init : String -> ( Model, Cmd Msg )
init topic =
    ( Model topic "waiting.gif" True "Finding random cats..."
    , getRandomGif topic
    )



-- UPDATE


type Msg
    = MorePlease
    | NewGif (Result Http.Error String)
    | ChangeTopic String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( model, getRandomGif model.topic )

        NewGif (Ok newUrl) ->
            ( Model
                model.topic
                newUrl
                False
                ""
            , Cmd.none
            )

        NewGif (Err errMsg) ->
            ( Model
                model.topic
                model.gifUrl
                True
                (toString errMsg)
            , Cmd.none
            )

        ChangeTopic newTopic ->
            ( Model
                newTopic
                model.gifUrl
                False
                ""
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "😸 Get Random Gifs 😸" ]
        , label []
            [ text "topic: "
            , input [ onInput ChangeTopic, value model.topic ] []
            ]
        , br [] []
        , button [ onClick MorePlease ] [ text "More Please!" ]
        , maybeErrorMsg model
        , br [] []
        , img [ src model.gifUrl ] []
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag="
                ++ topic
    in
        Http.send NewGif (Http.get url decodeGifUrl)


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
    Decode.at [ "data", "image_url" ] Decode.string



-- View Helpers


maybeErrorMsg : Model -> Html Msg
maybeErrorMsg model =
    if model.isErroneous then
        p [] [ text model.errMsg ]
    else
        p [] []
