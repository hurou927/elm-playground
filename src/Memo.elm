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

type Msg = Input String | Submit | Delete | Toggle Int

update: Msg -> Model -> Model
update msg model =
  case msg of Input input        -> {model | input = input}
              Submit             -> 
                let memo = { contents = model.input, isChecked = False} in
                  {model | input = "", memos = memo :: model.memos}
              Delete             ->
                let newMemo = List.filter (\memo -> not memo.isChecked) model.memos in
                  {model | memos = newMemo}
              Toggle no          ->
                let newMemo = List.indexedMap
                                (\index memo -> if index == no then {memo | isChecked = not memo.isChecked} else memo)
                                model.memos in
                  {model | memos = newMemo}

view: Model -> Html Msg
view model= div [] [
    Html.form [onSubmit Submit] [
      input [value model.input, onInput Input ] []
      , button [disabled <| String.length model.input < 1] [text "Submit"]
    ]
    , ul [] (List.indexedMap viewMemo model.memos)
    , button [ onClick Delete, disabled <| List.isEmpty model.memos || List.foldl (&&) True (List.map (\memo -> not memo.isChecked) model.memos)  ] [text "Delete"]
  ]

viewMemo: Int -> Memo -> Html Msg
viewMemo no memo = li []  [ div [] [
    input [type_ "checkbox", onClick <| Toggle no, checked <| memo.isChecked] []
    , text memo.contents]
  ]

