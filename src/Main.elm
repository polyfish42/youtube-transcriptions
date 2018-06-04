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
    case parse (many paragraph) transcription of
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


paragraph : Parser state String
paragraph =
    whitespace
        *> openingTag "p"
        *> (manyTill word (or emptyParagraph (closingTag "p"))
                |> map (String.join "")
           )
        <* whitespace


emptyParagraph : Parser state String
emptyParagraph =
    string "\n</p>"


word : Parser state String
word =
    openingTag "s"
        *> manyTill anyCharacter (closingTag "s")
        |> map (String.join "")


anyCharacter : Parser state String
anyCharacter =
    regex "."


openingTag : String -> Parser state (List String)
openingTag name =
    string ("<" ++ name) *> manyTill anyCharacter (string ">")


closingTag : String -> Parser state String
closingTag name =
    string ("</" ++ name ++ ">")
