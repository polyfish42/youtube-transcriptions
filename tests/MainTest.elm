module MainTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Main
import Test exposing (..)


suite : Test
suite =
    describe "Parsing YouTube trascript markup"
        [ describe "Main.parse"
            [ test "parses on paragraph" <|
                \_ ->
                    let
                        transcription =
                            "<s t=\"1410\" ac=\"252\"> here</s>"
                    in
                    Expect.equal (Main.parseTranscriptionXML transcription) (Ok " here")
            ]
        ]
