module Main exposing (..)

import Combine exposing ((*>), (<*), Parser, between, many, manyTill, parse, regex, string)


parseTranscriptionXML : String -> Result String String
parseTranscriptionXML transcription =
    case parse word transcription of
        Ok ( _, stream, result ) ->
            Ok (String.join "" result)

        Err ( _, stream, errors ) ->
            Err (String.join " or " errors)


word : Parser state (List String)
word =
    openingWordTag *> manyTill anyCharacter closingWordTag


openingWordTag : Parser state (List String)
openingWordTag =
    string "<s" *> manyTill anyCharacter (string ">")


closingWordTag : Parser state String
closingWordTag =
    string "</s>"


anyCharacter : Parser state String
anyCharacter =
    regex "."
