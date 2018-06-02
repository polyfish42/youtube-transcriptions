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
                        transcriptXML =
                            """
                        <p t="0" d="5009" w="1"><s p="2" ac="68">I&#39;m</s><s t="510" ac="252"> just</s><s t="1410" ac="252"> here</s><s p="1" t="1589" ac="219"> to</s><s t="1709" ac="252"> say</s><s t="1920" ac="252"> what</s><s t="2220" ac="240"> works</s><s p="2" t="2700" ac="124"> for</s><s p="2" t="3030" ac="165"> me</s></p>
                        """
                    in
                    Expect.equal (Main.parse transcriptXML) "I'm just here to say what works for me"
            ]
        ]