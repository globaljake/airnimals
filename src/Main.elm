module Main exposing (main)

import Browser exposing (Document)
import Browser.Events
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Decode as Decode exposing (Value)


type alias Model =
    { time : Int }


init : Value -> ( Model, Cmd Msg )
init flags =
    ( { time = 0 }, Cmd.none )



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Airnimals"
    , body = [ viewRoot model ]
    }


viewRoot : Model -> Html Msg
viewRoot model =
    Html.div [ Attributes.class "flex flex-col fixed inset-0 h-full items-center bg-blue-200" ]
        [ Html.div [ Attributes.class "flex items-center h-full" ]
            [ Html.div [ Attributes.class "flex" ]
                [ viewAnimatedAirnimal model Tiger
                , viewAnimatedAirnimal model Gator
                , viewAnimatedAirnimal model Penguin
                ]
            ]
        ]


type Airnimal
    = Tiger
    | Gator
    | Penguin


type Sprite
    = Idle
    | Idle2
    | Blink
    | Fall
    | Fall2


viewAnimatedAirnimal : Model -> Airnimal -> Html Msg
viewAnimatedAirnimal model airnimal =
    let
        n =
            10

        sprite =
            if modBy (n * 40) model.time < n then
                Blink

            else if modBy (n * 69) model.time < n then
                Blink

            else if modBy (n * 2) model.time < n then
                Idle

            else
                Idle2
    in
    viewAirnimal airnimal sprite


viewAirnimal : Airnimal -> Sprite -> Html Msg
viewAirnimal airnimal sprite =
    let
        vby =
            (*) 180 <|
                case airnimal of
                    Tiger ->
                        0

                    Gator ->
                        1

                    Penguin ->
                        2

        vbx =
            (*) 180 <|
                case sprite of
                    Idle ->
                        0

                    Idle2 ->
                        1

                    Blink ->
                        2

                    Fall ->
                        3

                    Fall2 ->
                        4

        toViewBox ( x, y ) =
            String.concat
                [ "images/airnimal-spritesheet.svg#svgView(viewBox("
                , String.fromInt x ++ ","
                , String.fromInt y ++ ","
                , "180,180))"
                ]
    in
    Html.img
        [ Attributes.src (toViewBox ( vbx, vby ))
        , Attributes.style "height" "90px"
        , Attributes.style "width" "90px"
        ]
        []



-- UPDATE


type Msg
    = AnimationFrame Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AnimationFrame time ->
            ( { model | time = model.time + 1 }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Browser.Events.onAnimationFrameDelta AnimationFrame


main : Program Value Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
