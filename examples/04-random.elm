module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Random


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { dieFace : Int
    , otherDieFace : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model 1 1, Cmd.none )



-- UPDATE


type Msg
    = Roll
    | NewFace Int
    | OtherNewFace Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace (Random.int 1 6) )

        NewFace newFace ->
            ( Model newFace model.otherDieFace
            , Random.generate OtherNewFace (Random.int 1 6)
            )

        OtherNewFace newFace ->
            ( Model model.dieFace newFace, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text (toString model.dieFace) ]
        , imageForFace model.dieFace
        , h2 [] [ text (toString model.otherDieFace) ]
        , imageForFace model.otherDieFace
        , button [ onClick Roll ] [ text "Roll" ]
        ]



-- TODO use img instead of p when real images exist


imageForFace : Int -> Html Msg
imageForFace dieFace =
    p []
        [ text
            ("static/img/die_faces/"
                ++ toString dieFace
                ++ ".png"
            )
        ]
