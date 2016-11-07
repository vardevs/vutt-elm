module Main exposing (..)

import Html exposing (Html, div, text, ul, li, node, footer, p, span)
import Html.Attributes exposing (classList, id, rel, href)
import Html.Events exposing (onClick)
import Html.App as App

main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


-- MODEL


type alias Model =
    { emails : List Email
    }


type alias Email =
    { id : Int
    , sender : String
    , subject : String
    , body : String
    , date: String
    , isSelected : Bool
    }


model : Model
model =
    { emails =
        [ { id = 1
          , subject = "Hello You"
          , sender = "foo@bar.com"
          , body = "Elming like an Elk"
          , date = "2014-01-01"
          , isSelected = False
          }
        , { id = 2
          , subject = "Hello You"
          , sender = "foo@bar.com"
          , body = "Hey you penis"
          , date = "2015-01-01"
          , isSelected = False
          }
        , { id = 3
          , subject = "For kicks"
          , sender = "foo@bar.com"
          , body = "Sure thing, Jim"
          , date = "2016-01-01"
          , isSelected = False
          }
        ]
    }

init : (Model, Cmd Msg)
init = 
  (model, Cmd.none)



-- UPDATE


type Msg
    = Select Email

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Select email ->
            let
                select item =
                    if item.id == email.id then
                        { item | isSelected = True }
                    else
                        { item | isSelected = False }
            in
                ({ model | emails = List.map select model.emails }, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- VIEW HELPERS

toListItem : Email -> Html Msg
toListItem item =
    li
        [ classList [ ( "thread-active", item.isSelected ) ]
        , onClick (Select item)
        ]
        [ span 
            [ classList [ ("text-after", True) ] ] 
            [ text item.date ]
        , span
            [ classList [ ("text-after", True) ] ] 
            [ text item.sender ]
        , span
            [ classList [ ("text-after", True) ] ] 
            [ text item.subject ]
        ]


showSelectedEmails : List Email -> Html Msg
showSelectedEmails emails =
  case List.head emails of
    Just email -> div []
        [ footer []
            [ p []
                [ text ("--date:" ++ email.date ++ "--thread:" ++ email.subject ++ "--") ]
            ]
        , p []
            [ text email.body ]
        ]


    Nothing -> text ""


css : String -> Html Msg
css path =
      Html.node "link" [ rel "stylesheet", href path ] []


-- VIEW

view : Model -> Html Msg
view model =
    let
        selectedEmails = 
            (List.filter .isSelected model.emails)
    in
        div [ id "root" ]
            [ css "main.css"
            , p []
                [ span
                    [ classList [ ("text-after", True) ] ]
                    [ text "q:Quit" ]
                , span
                    [ classList [ ("text-after", True) ] ]
                    [ text "d:Del" ]
                , span
                    [ classList [ ("text-after", True) ] ]
                    [ text "r:Reply" ]
                , span
                    [ classList [ ("text-after", True) ] ]
                    [ text "?:Help" ]
                ]
            , div []
                [ ul []
                    (List.map toListItem model.emails)
                ]
            , div []
                [ showSelectedEmails selectedEmails
                , footer []
                    [ p []
                        [ text "--vutt: [EOM]--" ]
                    ]
                ]
            ]
