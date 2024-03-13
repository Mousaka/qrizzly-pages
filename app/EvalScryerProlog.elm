port module EvalScryerProlog exposing (..)

port eval : String -> Cmd msg
port scryerResultReceiver : (String -> msg) -> Sub msg
