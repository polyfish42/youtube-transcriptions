module Main exposing (..)

import Combine exposing ((*>), (<*), Parser, between, many, manyTill, map, parse, regex, string, whitespace)


parseTranscriptionXML : String -> Result String String
parseTranscriptionXML transcription =
    case parse (many textWithoutWhitespace) transcription of
        Ok ( _, stream, result ) ->
            Ok (String.join "" result)

        Err ( _, stream, errors ) ->
            Err (String.join " or " errors)


textWithoutWhitespace : Parser state String
textWithoutWhitespace =
    whitespace *> paragraph <* whitespace


paragraph : Parser state String
paragraph =
    openingParagraphTag
        *> manyTill word (string "</p>")
        |> map (String.join "")


openingParagraphTag : Parser state (List String)
openingParagraphTag =
    string "<p" *> manyTill anyCharacter (string ">")


closingParagraphTag : Parser state String
closingParagraphTag =
    string "</p>"


word : Parser state String
word =
    openingWordTag
        *> manyTill anyCharacter closingWordTag
        |> map (String.join "")


openingWordTag : Parser state (List String)
openingWordTag =
    string "<s" *> manyTill anyCharacter (string ">")


closingWordTag : Parser state String
closingWordTag =
    string "</s>"


anyCharacter : Parser state String
anyCharacter =
    regex "."
