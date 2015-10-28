module StartLambda (start, Config, App) where

import Task
import Effects exposing (Effects, Never)


type alias Config model action =
    { init : (model, Effects action)
    , update : action -> model -> (model, Effects action)
    , inputs : List (Signal.Signal action)
    }


type alias App model =
    { model : Signal model
    , tasks : Signal (Task.Task Never ())
    }


start : Config model action -> App model
start config =
  let
    singleton action =
      [ action ]

    -- messages : Signal.Mailbox (List action)
    messages =
      Signal.mailbox []

    -- address : Signal.Address action
    address =
      Signal.forwardTo messages.address singleton

    -- updateStep : action -> (model, Effects action) -> (model, Effects action)
    updateStep action (oldModel, accumulatedEffects) =
      let
        (newModel, additionalEffects) = config.update action oldModel
      in
        (newModel, Effects.batch [accumulatedEffects, additionalEffects])

    -- update : List action -> (model, Effects action) -> (model, Effects action)
    update actions (model, _) =
      List.foldl updateStep (model, Effects.none) actions

    -- inputs : Signal (Maybe action)
    inputs =
      Signal.mergeMany (messages.signal :: List.map (Signal.map singleton) config.inputs)

    -- effectsAndModel : Signal (model, Effects action)
    effectsAndModel =
      Signal.foldp update config.init inputs

    model =
      Signal.map fst effectsAndModel

  in
    { model = model
    , tasks = Signal.map (Effects.toTask address << snd) effectsAndModel
    }
