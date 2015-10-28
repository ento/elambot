module Elambot.Model where

import Json.Decode exposing (..)
import Json.Decode.Extra exposing (apply)


(|:) = Json.Decode.Extra.apply


type alias Model =
  { token : String
  , teamId : String
  , teamDomain : String
  , serviceId : String
  , channelId : String
  , channelName : String
  , timestamp : String
  , userId : String
  , userName : String
  , text : String
  }


decodeModelJson : Value -> Result String Model
decodeModelJson jsonValue =
    Json.Decode.decodeValue model jsonValue


model : Decoder Model
model =
  succeed Model
    |: ("token" := string)
    |: ("team_id" := string)
    |: ("team_domain" := string)
    |: ("service_id" := string)
    |: ("channel_id" := string)
    |: ("channel_name" := string)
    |: ("timestamp" := string)
    |: ("user_id" := string)
    |: ("user_name" := string)
    |: ("text" := string)


initModel : Model
initModel =
  Model
  "" -- token
  "" -- team_id
  "" -- team_domain
  "" -- service_id
  "" -- channel_id
  "" -- channel_name
  "" -- timestamp
  "" -- user_id
  "" -- user_name
  "" -- text
