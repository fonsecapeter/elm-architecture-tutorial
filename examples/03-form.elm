module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Char


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }


model : Model
model =
    Model "" "" ""



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", placeholder "Name", onInput Name ] []
        , input [ type_ "password", placeholder "Password", onInput Password ] []
        , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
        , viewValidation model
        ]


viewValidation : Model -> Html msg
viewValidation model =
    let
        ( isValid, message ) =
            validPassword model.password model.passwordAgain

        color =
            if isValid then
                "green"
            else
                "red"
    in
        div [ style [ ( "color", color ) ] ]
            [ p [] [ text message ]
            , button [ disabled (not isValid) ] [ text "submit" ]
            ]


validPassword : String -> String -> ( Bool, String )
validPassword password passwordAgain =
    if String.length password < 8 then
        ( False, "Passwrod must be at least 8 chars" )
    else if not (String.any Char.isDigit password) then
        ( False, "Password must contain at least one digit" )
    else if not (String.any Char.isUpper password) then
        ( False, "Password must contain at least one upper-case letter" )
    else if not (String.any Char.isLower password) then
        ( False, "Password must contain at least one lower-case letter" )
    else if not (password == passwordAgain) then
        ( False, "Password do not match!" )
    else
        ( True, "OK" )
