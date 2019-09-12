import Browser
import Html exposing (Html, button, div, text, li, ul, input)
import Html.Attributes exposing (type_, checked, value, disabled)
import Html.Events exposing (onSubmit, onInput, onClick)

main: Program () Model Msg
main = Browser.sandbox {init=init, update=update, view=view}

type alias Memo = {contents: String, isChecked: Bool}

type alias Model = {input: String, memos: List Memo}

init: Model
init = {input = "", memos = []}

type Msg = Input String | Submit | Delete | Check Int Bool

update: Msg -> Model -> Model
update msg model =
  case msg of Input input        -> {model | input = input}
              Submit             -> 
                let memo = { contents = model.input, isChecked = False} in
                  {model | input = "", memos = memo :: model.memos}
              Delete             -> model
              Check no isChecked -> model

view: Model -> Html Msg
view model= div [] [
    Html.form [onSubmit Submit] [
      input [value model.input, onInput Input ] []
      , button [disabled (String.length model.input < 1)] [text "Submit"]
    ]
    , ul [] (List.indexedMap viewMemo model.memos)
    , button [] [text "Delete"]
  ]

viewMemo: Int -> Memo -> Html Msg
viewMemo no memo = li []  [ div [] [
    input [type_ "checkbox", onClick (Check no memo.isChecked)] []
    , text memo.contents]
  ]

