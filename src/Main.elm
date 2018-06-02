module Main exposing (..)

import Combine exposing (parse)


parseTranscriptionXML : String -> Result String String
parseTranscriptionXML transcription =
    case parse (Combine.string "hello") transcription of
        Ok ( _, stream, result ) ->
            Ok result

        Err ( _, stream, errors ) ->
            Err (String.join " or " errors)
