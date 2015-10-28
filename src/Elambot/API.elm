module Elambot.API where

import Signal exposing (Signal, Address, Mailbox)
import Task exposing (Task)
import Effects exposing (Never, Effects)
import Json.Decode exposing (Value)
import StartLambda

import Elambot.Model exposing (Model, decodeModelJson, initModel)
import Elambot.Update exposing (Action(..), update)


app : StartLambda.App Model
app =
    let
        decodeResult =
            modelJson
            |> decodeModelJson

        initAction =
          case decodeResult of
            Ok model ->
              InitAction model Request
            Err message ->
              InitAction initModel (DecodeError message)

        config =
            StartLambda.Config
                (initAction.model, Effects.task (Task.succeed initAction.action))
                (update responseMailbox.address)
                []
    in
        StartLambda.start config


type alias InitAction =
  { model : Model
  , action : Action
  }


responseMailbox : Signal.Mailbox String
responseMailbox =
    Signal.mailbox ""


port modelJson : Value


port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks


port response : Signal String
port response =
    responseMailbox.signal
