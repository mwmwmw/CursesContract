// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./Base64.sol";
import "./ICurses.sol";

contract CurseGenerator {
    string[7] internal types = [
        "Ancient",
        "Legendary",
        "Arcane",
        "Mystical",
        "Void",
        "Tyrannical",
        "Unholy"
    ];
    string[16] internal quality = [
        "Diabolical",
        "Visionary",
        "Godlike",
        "Prophetic",
        "Glib",
        "Destitute",
        "Impious",
        "Blasphemous",
        "Sacrilegious",
        "Irreverent",
        "Wicked",
        "Evil",
        "Corrupt",
        "Depraved",
        "Infernal",
        "Romantic"
    ];
    string internal constant svgElementOpen =
        '<svg width="100%" height="100%" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><rect x="0" y="0" width="1024" height="1024" style="fill: #0f070f;" clip-path="url(#c)" />';
    string internal constant svgElementClose = "</svg>";
    string internal constant defs =
        '<defs><path id="cc" d="M62,512a450,450 0 1,0 900,0a450,450 0 1,0 -900,0" /><pattern id="rects" x="0" y="0" width="64" height="64" patternUnits="userSpaceOnUse"><rect x="0" y="0" width="64" height="64" /><rect x="0" y="32" width="64" height="64" /></pattern><filter id="df" x="0" y="0"><feTurbulence id="t" type="turbulence" baseFrequency="0.001" numOctaves="5" result="t" seed="';
    string internal constant defs2 =
        '" /><feGaussianBlur in="t" result="blur" stdDeviation="5 7" /><feDisplacementMap in2="SourceGraphic" in="blur" scale="100" xChannelSelector="R" yChannelSelector="G" result="displace" /><feSpecularLighting in="displace" specularExponent="100" lighting-color="#ffffff" surfaceScale="50" result="specOut"><fePointLight x="64" y="64" z="500" /></feSpecularLighting><feComposite in="t" in2="specOut" operator="in" /></filter><style>@font-face {font-family: "Witchfinger";src: url("https://ipfs.io/ipfs/QmepSomSdboBop8EaFC15qTeK1FXqNk73dWcfWXMcx4eds?filename=Witchfinger.woff2") format("woff2")}#text {font-size: 40px;font-family: "Witchfinger";letter-spacing: 8px;fill: rgba(255, 50, 200, 0.7);}g path,g circle {stroke-width: 3px;stroke: rgba(255, 200, 255, 0.6);fill: none;stroke-linejoin:round;transform-origin: center center;}#rects rect {fill: rgba(200,100,250,0.2);}@keyframes pulse {0% {opacity: .6;}50% {opacity: 1;}100% {opacity: 0.6;}}@keyframes rot {0% {transform: rotate(0deg);}100% {transform: rotate(360deg);}}textPath {animation: pulse 1s linear infinite;}#ct {animation: rot 77s linear infinite;transform: rotate(0deg);transform-origin: center center;}#r {animation: rot 60s linear reverse infinite;transform: rotate(0deg);transform-origin: center center;}#grid {opacity: 0.1;}</style><clipPath id="ci"><circle cx="512" cy="512" r="400" /></clipPath><clipPath id="c"><circle cx="512" cy="512" r="474" /></clipPath></defs>';
    string internal constant setup =
        '<g id="r"><rect x="0" y="0" width="1024" height="1024" style="fill: url(#p);" /><rect x="0" y="0" width="1024" height="1024" style="fill: url(#p); transform: rotate(120deg); transform-origin: 50% 50%;" /><rect x="0" y="0" width="1024" height="1024" style="fill: url(#p); transform: rotate(240deg); transform-origin: 50% 50%;" /></g><g><circle cx="512" cy="512" r="475" /><circle cx="512" cy="512" r="465" /></g><g><circle cx="512" cy="512" r="400" /><circle cx="512" cy="512" r="410" /></g><text id="ct" lengthAdjust="spacing"><textPath id="text" href="#cc" textLength="2827"><![CDATA[';
    string internal constant setup2 = "]]>.&#160;</textPath></text>";

    string internal constant json1 = '{"name":"';
    string internal constant json2 = '","description":"';
    string internal constant json3 = '","image":"data:image/svg+xml;base64,';
    string internal constant json4 = '"}';
    string internal constant json5 = '}';

    string internal constant trait1 = '{"trait_type":"';
    string internal constant trait2 = '","value": "';
    string internal constant trait3 = '","value":';

    // modified from openzepplin jswt lib
    function len(string memory str) internal pure returns (uint) {
        
        bytes32 self;

        assembly {
            self := mload(add(str, 32))
        }

        uint ret;
        if (self == 0)
            return 0;
        if (self & bytes32(uint256(0xffffffffffffffffffffffffffffffff)) == 0) {
            ret += 16;
            self = bytes32(uint(self) / 0x100000000000000000000000000000000);
        }
        if (self & bytes32(uint256(0xffffffffffffffff)) == 0) {
            ret += 8;
            self = bytes32(uint(self) / 0x10000000000000000);
        }
        if (self & bytes32(uint256(0xffffffff)) == 0) {
            ret += 4;
            self = bytes32(uint(self) / 0x100000000);
        }
        if (self & bytes32(uint256(0xffff)) == 0) {
            ret += 2;
            self = bytes32(uint(self) / 0x10000);
        }
        if (self & bytes32(uint256(0xff)) == 0) {
            ret += 1;
        }
        return 32 - ret;
    }

    function trait(string memory name, string memory value)
        public
        pure
        returns (bytes memory)
    {
        return bytes(abi.encodePacked(trait1, name, trait2, value, json4));
    }

    function traitNum(string memory name, string memory value)
        public
        pure
        returns (bytes memory)
    {
        return bytes(abi.encodePacked(trait1, name, trait3, value, json5));
    }


    function getAttributes(ICurses.Curse memory curse)
        public
        view
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    '","attributes": [',
                        trait("Type", 
                            types[len(curse.name) % 7]),
                        ",",
                        trait(
                            "Quality",
                            quality[len(curse.description) % 16]),
                        ",",
                        traitNum(
                            "Hate",
                            Strings.toString(curse.magic[0]%256)),
                        ",",
                        traitNum(
                            "Malice",
                            Strings.toString(curse.magic[1]%256)),
                        ",",
                        traitNum(
                            "Power",
                            Strings.toString(curse.magic[2]%256)),
                    "]"
                )
            );
    }

    function finalData(
        string memory name,
        string memory description,
        string memory svg,
        string memory attributes
    ) public pure returns (bytes memory) {
        return
            bytes(
                abi.encodePacked(
                    json1,
                    name,
                    json2,
                    description,
                    json3,
                    svg,
                    attributes,
                    json5
                )
            );
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(bytes(input)));
    }

    function sRandom(
        uint256 tokenId,
        uint256 seed,
        uint256 min,
        uint256 max
    ) public pure returns (uint256) {
        uint256 rand = random(
            string(abi.encodePacked(seed, Strings.toString(tokenId)))
        );
        rand = min + (rand % (max - min));
        return uint256(rand);
    }

    function rectPattern(
        uint256 tokenId,
        uint256 seed,
        uint256[6] memory nb
    ) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<pattern id="rects" x="0" y="0" width="64" height="64" patternUnits="userSpaceOnUse">',
                    rect(
                        0,
                        0,
                        sRandom(tokenId * (2239 * nb[0]), seed, 16, 64),
                        sRandom(tokenId * (2381 * nb[1]), seed, 16, 64)
                    ),
                    rect(
                        0,
                        0,
                        sRandom(tokenId * (2549 * nb[2]), seed, 16, 64),
                        sRandom(tokenId * (2699 * nb[3]), seed, 16, 64)
                    ),
                    rect(
                        0,
                        0,
                        sRandom(tokenId * (2269 * nb[4]), seed, 16, 64),
                        sRandom(tokenId * (4391 * nb[5]), seed, 16, 64)
                    ),
                    rect(
                        0,
                        0,
                        sRandom(tokenId * (2269 * nb[2]), seed, 16, 64),
                        sRandom(tokenId * (4391 * nb[1]), seed, 16, 64)
                    ),
                    "</pattern>"
                )
            );
    }

    function rect(
        uint256 x,
        uint256 y,
        uint256 w,
        uint256 h
    ) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<rect x="',
                    Strings.toString(x),
                    '" y="',
                    Strings.toString(y),
                    '" width="',
                    Strings.toString(w),
                    '" height="',
                    Strings.toString(h),
                    '" />'
                )
            );
    }

    function lineTo(uint256[2] memory p) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "L",
                    Strings.toString(p[0]),
                    ",",
                    Strings.toString(p[1])
                )
            );
    }

    function moveTo(uint256[2] memory p) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "M",
                    Strings.toString(p[0]),
                    ",",
                    Strings.toString(p[1])
                )
            );
    }

    function path(
        uint256 tokenId,
        uint256 seed,
        uint256[2] memory start,
        uint256[2] memory end,
        uint256[6] memory nb
    ) internal pure returns (string memory) {
        uint256[2] memory midPoint = [
            sRandom(tokenId * (nb[0] * 4129), seed, 128, 768),
            sRandom(tokenId * (nb[1] * 4111), seed, 128, 768)
        ];

        uint256[2] memory midPoint2 = [
            sRandom(tokenId * (nb[2] * 4127), seed, 128, 768),
            sRandom(tokenId * (nb[3] * 4129), seed, 128, 768)
        ];

        return
            string(
                abi.encodePacked(
                    '<path d="',
                    moveTo(start),
                    lineTo(midPoint),
                    lineTo(midPoint2),
                    lineTo(end),
                    '" />'
                )
            );
    }

    function circle(
        uint256 x,
        uint256 y,
        uint256 r
    ) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<circle cx="',
                    Strings.toString(x),
                    '" cy="',
                    Strings.toString(y),
                    '" r="',
                    Strings.toString(r),
                    '" />'
                )
            );
    }

    function mainImage(
        uint256 tokenId,
        uint256 seed,
        uint256[6] memory nb
    ) internal pure returns (string memory) {
        uint256[2] memory startPoint = [
            sRandom(tokenId * (1303 * nb[0]), seed, 128, 768),
            sRandom(tokenId * (1471 * nb[1]), seed, 128, 768)
        ];
        uint256[2] memory endPoint = [
            sRandom(tokenId * (1607 * nb[2]), seed, 128, 768),
            sRandom(tokenId * (1753 * nb[3]), seed, 128, 768)
        ];

        return
            string(
                abi.encodePacked(
                    '<pattern id="p" x="0" y="0" width="1" height="1"><g clip-path="url(#ci)" id="sigil"><rect x="0" y="0" width="1024" height="1024" style="fill: url(#rects); filter: url(#df);" /><g id="circles">',
                    circle(
                        startPoint[0],
                        startPoint[1],
                        sRandom(tokenId * (1913 * nb[4]), seed, 16, 128)
                    ),
                    circle(
                        endPoint[0],
                        endPoint[1],
                        sRandom(tokenId * (2081 * nb[5]), seed, 16, 128)
                    ),
                    '</g><g id="lines">',
                    path(tokenId, seed, startPoint, endPoint, nb),
                    "</g></g></pattern>"
                )
            );
    }

    function tokenURI(uint256 tokenId, ICurses.Curse memory curse)
        external
        view
        returns (string memory)
    {
        string memory meta = Base64.encode(
            finalData(
                curse.name,
                curse.description,
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            svgElementOpen,
                            defs,
                            Strings.toString(curse.seed % 9999999),
                            defs2,
                            rectPattern(tokenId + 1, curse.seed, curse.magic),
                            mainImage(tokenId + 1, curse.seed, curse.magic),
                            setup,
                            curse.name,
                            setup2,
                            svgElementClose
                        )
                    )
                ),
                getAttributes(curse)
            )
        );

        return string(abi.encodePacked("data:application/json;base64,", meta));
    }
}
