module Main exposing (..)

import Combine
    exposing
        ( (*>)
        , (<*)
        , Parser
        , between
        , many
        , manyTill
        , map
        , optional
        , or
        , parse
        , regex
        , skip
        , string
        , whitespace
        )


parseTranscriptionXML : String -> Result String String
parseTranscriptionXML transcription =
    case parse (many textWithoutWhitespace) transcription of
        Ok ( _, stream, result ) ->
            Ok (joinResult result)

        Err ( _, stream, errors ) ->
            Err (String.join " or " errors)


joinResult : List String -> String
joinResult result =
    case result of
        x :: xs ->
            case x of
                "" ->
                    joinResult xs

                _ ->
                    x ++ " " ++ joinResult xs

        [] ->
            ""


textWithoutWhitespace : Parser state String
textWithoutWhitespace =
    whitespace *> paragraph <* whitespace


paragraph : Parser state String
paragraph =
    openingParagraphTag
        *> manyTill word (or emptyParagraph (string "</p>"))
        |> map (String.join "")


emptyParagraph : Parser state String
emptyParagraph =
    string "\n</p>"


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
