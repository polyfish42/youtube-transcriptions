module MainTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Main
import Test exposing (..)


suite : Test
suite =
    describe "Parsing YouTube trascript markup"
        [ describe "Main.parseTranscriptionXML"
            [ test "parses many words" <|
                \_ ->
                    let
                        transcription =
                            """
<p t="0" d="5009" w="1"><s p="2" ac="68">I'm</s><s t="510" ac="252"> just</s><s t="1410" ac="252"> here</s><s p="1" t="1589" ac="219"> to</s><s t="1709" ac="252"> say</s><s t="1920" ac="252"> what</s><s t="2220" ac="240"> works</s><s p="2" t="2700" ac="124"> for</s><s p="2" t="3030" ac="165"> me</s></p>
<p t="3139" d="1870" w="1" a="1">
</p>
<p t="3149" d="4051" w="1"><s ac="242">because</s><s p="2" t="300" ac="165"> you</s><s p="1" t="631" ac="216"> know</s><s t="721" ac="252"> sometimes</s><s p="2" t="1051" ac="143"> people</s><s t="1710" ac="252"> come</s></p>
<p t="4999" d="2201" w="1" a="1">
</p>
                            """
                    in
                    Expect.equal (Main.parseTranscriptionXML transcription) (Ok "I'm just here to say what works for me because you know sometimes people come ")
            ]
        ]