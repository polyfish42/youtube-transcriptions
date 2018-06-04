module Main exposing (..)

import Combine
    exposing
        ( (*>)
        , (<*)
        , Parser
        , andThen
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
import Regex


parseTranscriptionXML : String -> Result String String
parseTranscriptionXML transcription =
    case parse transcriptionXML (noWhitespace transcription) of
        Ok ( _, stream, result ) ->
            Ok (joinResult result)

        Err ( _, stream, errors ) ->
            Err (String.join " or " errors)


noWhitespace : String -> String
noWhitespace string =
    Regex.replace Regex.All (Regex.regex "\n") (\_ -> "") string


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


transcriptionXML : Parser state (List String)
transcriptionXML =
    openingTag "?xml"
        *> openingTag "timedtext"
        *> head
        *> openingTag "body"
        *> emptyTag "w"
        *> many paragraph
        <* closingTag "body"
        <* closingTag "timedtext"


head : Parser state (List String)
head =
    openingTag "head" *> manyTill anyCharacter (closingTag "head")


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


emptyTag : String -> Parser state (List String)
emptyTag name =
    string ("<" ++ name) *> manyTill anyCharacter (string "/>")
