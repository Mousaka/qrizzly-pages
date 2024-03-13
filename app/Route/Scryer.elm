module Route.Scryer exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import Effect
import ErrorPage
import EvalScryerProlog exposing (eval, scryerResultReceiver)
import FatalError
import Head
import Html
import Html.Attributes exposing (value)
import Layout.Scryer
import PagesMsg
import RouteBuilder
import Server.Request
import Server.Response
import Shared
import UrlPath
import View


type alias Model =
    { evalRes :
        String
    , code : String
    }


type Msg
    = NoOp
    | ScryerMsg String


type alias RouteParams =
    {}


route : RouteBuilder.StatefulRoute RouteParams Data ActionData Model Msg
route =
    RouteBuilder.serverRender { data = data, action = action, head = head }
        |> RouteBuilder.buildWithLocalState
            { view = view
            , init = init
            , update = update
            , subscriptions = subscriptions
            }


initCode : String
initCode =
    """
               :- use_module(library(format)).
               :- use_module(library(clpz)).
               :- use_module(library(lists)).
               
               sudoku(Rows) :-
                   length(Rows, 9), maplist(same_length(Rows), Rows),
                   append(Rows, Vs), Vs ins 1..9,
                   maplist(all_distinct, Rows),
                   transpose(Rows, Columns),
                   maplist(all_distinct, Columns),
                   Rows = [As,Bs,Cs,Ds,Es,Fs,Gs,Hs,Is],
                   blocks(As, Bs, Cs),
                   blocks(Ds, Es, Fs),
                   blocks(Gs, Hs, Is).
               
               blocks([], [], []).
               blocks([N1,N2,N3|Ns1], [N4,N5,N6|Ns2], [N7,N8,N9|Ns3]) :-
               all_distinct([N1,N2,N3,N4,N5,N6,N7,N8,N9]),
               blocks(Ns1, Ns2, Ns3).
               
               problem(1, [[_,_,_,_,_,_,_,_,_],
                           [_,_,_,_,_,3,_,8,5],
                           [_,_,1,_,2,_,_,_,_],
                           [_,_,_,5,_,7,_,_,_],
                           [_,_,4,_,_,_,1,_,_],
                           [_,9,_,_,_,_,_,_,_],
                           [5,_,_,_,_,_,_,7,3],
                           [_,_,2,_,1,_,_,_,_],
                           [_,_,_,_,4,_,_,_,9]]).
               
               main :-
                   problem(1, Rows), sudoku(Rows), maplist(portray_clause, Rows).
               
               :- initialization(main).
       """


init :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> ( Model, Effect.Effect Msg )
init app shared =
    ( { evalRes = "", code = initCode }, Effect.Cmd (eval initCode) )


update :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Msg
    -> Model
    -> ( Model, Effect.Effect Msg )
update app shared msg model =
    case msg of
        NoOp ->
            ( model, Effect.none )

        ScryerMsg evalRes ->
            ( { model | evalRes = evalRes }, Effect.none )


subscriptions : RouteParams -> UrlPath.UrlPath -> Shared.Model -> Model -> Sub Msg
subscriptions routeParams path shared model =
    scryerResultReceiver ScryerMsg


type alias Data =
    {}


type alias ActionData =
    {}


data :
    RouteParams
    -> Server.Request.Request
    -> BackendTask.BackendTask FatalError.FatalError (Server.Response.Response Data ErrorPage.ErrorPage)
data routeParams request =
    BackendTask.succeed (Server.Response.render {})


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head app =
    []


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app shared model =
    { title = "Scryer"
    , body =
        [ Layout.Scryer.view model
        ]
    }


action :
    RouteParams
    -> Server.Request.Request
    -> BackendTask.BackendTask FatalError.FatalError (Server.Response.Response ActionData ErrorPage.ErrorPage)
action routeParams request =
    BackendTask.succeed (Server.Response.render {})
