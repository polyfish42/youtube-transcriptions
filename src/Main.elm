module Main exposing (..)

import Combine exposing (Parser, many, parse, regex)


parseTranscriptionXML : String -> Result String String
parseTranscriptionXML transcription =
    case parse word transcription of
        Ok ( _, stream, result ) ->
            Ok (String.join "" result)

        Err ( _, stream, errors ) ->
            Err (String.join " or " errors)


word : Parser state (List String)
word =
    many anyCharacter


anyCharacter : Parser state String
anyCharacter =
    regex "."
