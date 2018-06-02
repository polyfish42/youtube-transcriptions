module Main exposing (..)

import Combine exposing ((*>), (<*), Parser, between, many, manyTill, parse, regex, string, whitespace)


parseTranscriptionXML : String -> Result String String
parseTranscriptionXML transcription =
    case parse (many textWithoutWhitespace) transcription of
        Ok ( _, stream, result ) ->
            Ok (toSentence result)

        Err ( _, stream, errors ) ->
            Err (String.join " or " errors)


toSentence : List (List String) -> String
toSentence list =
    List.map (String.join "") list |> String.join ""


textWithoutWhitespace : Parser state (List String)
textWithoutWhitespace =
    whitespace *> word <* whitespace


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
