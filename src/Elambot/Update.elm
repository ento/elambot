module Elambot.Update where

import Effects exposing (Effects)
import Signal exposing (Address)
import Task

import Elambot.Model exposing (Model)


type Action
  = NoOp
  | Request
  | DecodeError String


update : Address String -> Action -> Model -> (Model, Effects Action)
update responseAddress action model =
  let
    sendResponse message =
      message
        |> Signal.send responseAddress
        |> Task.map (always NoOp)

  in
    case action of
      NoOp ->
        (model, Effects.none)

      Request ->
        (model, Effects.task (sendResponse ("Hello from Elm, " ++ model.userName ++ "!")))

      DecodeError message ->
        (model, Effects.task (sendResponse message))

      _ ->
        (model, Effects.task (sendResponse "@@ I'm confused"))
