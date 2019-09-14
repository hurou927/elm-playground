import Browser
import Html exposing(Html, button, div, text)
import Html.Events exposing (onClick)
import Json.Decode exposing (..)

main: Program () Model Msg
main =
    Browser.sandbox
        {
            init = init
            , update = update
            , view = view
        }

type alias Model = Int

init: Model
init = 0

type Msg = Message

update: Msg -> Model -> Model
update msg model = model


type alias User1 =
    { id : String
    , display_name : String
    }

userDecoder1 : Decoder User1
userDecoder1 =
    Json.Decode.map2 User1
        (Json.Decode.field "id"   Json.Decode.string)
        (Json.Decode.field "name" Json.Decode.string)


type alias User2 =
    { id : String
    , display_name : Maybe String
    }

userDecoder2 : Decoder User2
userDecoder2 =
    Json.Decode.map2 User2
        (Json.Decode.field "id"   <| Json.Decode.string)
        (Json.Decode.field "name" <| Json.Decode.nullable Json.Decode.string)


type alias Conf3 =
  { ids : List Int
    , enable: Bool
  }

type alias User3 =
    { id : String
    , display_name : Maybe String
    , config : Conf3
    }

userDecoder3 : Decoder User3
userDecoder3 =
    Json.Decode.map3 User3
        (Json.Decode.field "id"     <| Json.Decode.string)
        (Json.Decode.field "name"   <| Json.Decode.nullable Json.Decode.string)
        (Json.Decode.field "config" <| 
          Json.Decode.map2 Conf3
            (Json.Decode.field "ids"    <| Json.Decode.list Json.Decode.int)
            (Json.Decode.field "enable" <| Json.Decode.bool))


exjson1 = """ { "id": "id0", "name":"name0"} """
exjson2 = """ { "id": "id0", "name":null} """
exjson3 = """ { "id": "id0", "config": {"ids":[4,1,2], "enable":false} , "name": "name0" } """

view: Model -> Html Msg
view model = div 
    []
    [
      let 
        _ = Debug.log "basic" (decodeString userDecoder1 exjson1)
        _ = Debug.log "null"  (decodeString userDecoder1 exjson2)
        _ = Debug.log "null"  (decodeString userDecoder2 exjson2)
        _ = Debug.log "nest"  (decodeString userDecoder3 exjson3)
      in text "Hello"
    ]