// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

library CurseGenerator {
    string internal constant svgElementOpen =
        '<svg width="100%" height="100%" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><rect x="0" y="0" width="1024" height="1024" style="fill: #0f070f;" />';
    string internal constant svgElementClose = "</svg>";
    string internal constant defs =
        '<defs><path id="cc" d="M62,512a450,450 0 1,0 900,0a450,450 0 1,0 -900,0" /><filter id="df"><feTurbulence type="turbulence" baseFrequency="0.009" numOctaves="5" result="turbulence" seed="';
    string internal constant defs2 =
        '" /><feGaussianBlur in="SourceGraphic" result="blur" stdDeviation="4" /><feDisplacementMap in2="turbulence" in="blur" scale="30" xChannelSelector="R" yChannelSelector="G" /><feSpecularLighting result="specOut" specularExponent="100" lighting-color="#ff33aa" surfaceScale="10"><fePointLight x="64" y="64" z="50" /></feSpecularLighting><feDisplacementMap in2="turbulence" in="blur" scale="1" xChannelSelector="R" yChannelSelector="G" /><feComposite in="turbulence" in2="specOut" operator="in" /></filter><style> @font-face { font-family: "Witchfinger"; src: url("https://ipfs.io/ipfs/QmepSomSdboBop8EaFC15qTeK1FXqNk73dWcfWXMcx4eds?filename=Witchfinger.woff2") format("woff2"); } #ct { font-size: 40px; font-family: "Witchfinger", monospace; letter-spacing: 8px; fill: rgba(255, 50, 200, 0.7); } g path, g circle { stroke-width: 3px; stroke: rgba(255, 200, 255, 0.6); fill: none; stroke-linejoin="round" transform-origin: center center; } @keyframes pulse { 0% { opacity: .6; } 50% { opacity: 1; } 100% { opacity: 0.6; } } @keyframes rot { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } } textPath { animation: pulse 1s linear infinite; } #ct { animation: rot 77s linear infinite; transform: rotate(0deg); transform-origin: center center; } #r { animation: rot 60s linear reverse infinite; transform: rotate(0deg); transform-origin: center center; } </style><clipPath id="c"><circle cx="512" cy="512" r="400" /></clipPath></defs>';
    string internal constant setup =
        '<g id="r"><rect x="0" y="0" width="1024" height="1024" style="fill: url(#p);" /><rect x="0" y="0" width="1024" height="1024" style="fill: url(#p); transform: rotate(120deg); transform-origin: 50% 50%;" /><rect x="0" y="0" width="1024" height="1024" style="fill: url(#p); transform: rotate(240deg); transform-origin: 50% 50%;" /></g><g><circle cx="512" cy="512" r="475" /><circle cx="512" cy="512" r="465" /></g><g><circle cx="512" cy="512" r="400" /><circle cx="512" cy="512" r="410" /></g><text id="ct" lengthAdjust="spacing"><textPath id="text" href="#cc"><![CDATA[';
    string internal constant setup2 = "]]></textPath></text>";

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(bytes(input)));
    }

    function sRandom(
        uint256 tokenId,
        uint256 seed,
        uint16 min,
        uint16 max
    ) public view returns (uint16) {
        uint256 rand = random(
            string(
                abi.encodePacked(
                    seed,
                    block.timestamp,
                    Strings.toString(tokenId)
                )
            )
        );
        rand = min + (rand % (max - min));
        return uint16(rand);
    }

    function rectPattern(
        uint256 tokenId,
        uint256 seed,
        uint256[6] memory nb
    ) internal view returns (string memory) {
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
        uint16 x,
        uint16 y,
        uint16 w,
        uint16 h
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

    function lineTo(uint16[2] memory p) internal pure returns (string memory) {
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

    function moveTo(uint16[2] memory p) internal pure returns (string memory) {
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
        uint16[2] memory start,
        uint16[2] memory end,
        uint256[6] memory nb
    ) internal view returns (string memory) {
        uint16[2] memory midPoint = [
            sRandom(tokenId * (nb[0] * 4129), seed, 128, 768),
            sRandom(tokenId * (nb[1] * 4111), seed, 128, 768)
        ];

        uint16[2] memory midPoint2 = [
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
        uint16 x,
        uint16 y,
        uint16 r
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
    ) internal view returns (string memory) {
        uint16[2] memory startPoint = [
            sRandom(tokenId * (1303 * nb[0]), seed, 128, 768),
            sRandom(tokenId * (1471 * nb[1]), seed, 128, 768)
        ];
        uint16[2] memory endPoint = [
            sRandom(tokenId * (1607 * nb[2]), seed, 128, 768),
            sRandom(tokenId * (1753 * nb[3]), seed, 128, 768)
        ];

        return
            string(
                abi.encodePacked(
                    '<pattern id="p" x="0" y="0" width="1" height="1"><g clip-path="url(#c)" id="sigil"><rect x="0" y="0" width="1024" height="1024" style="fill: url(#rects); filter: url(#df); transform: scale(8)" /><g id="circles">',
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

    function makeSVG(
        uint256 tokenId,
        uint256 seed,
        string memory phrase,
        uint256[6] memory nb
    ) internal view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    svgElementOpen,
                    defs,
                    Strings.toString((bytes(phrase).length + seed * nb[3])%99999999),
                    defs2,
                    rectPattern(tokenId, seed * 7207, nb),
                    mainImage(tokenId, seed * 6469, nb),
                    setup,
                    phrase,
                    setup2,
                    svgElementClose
                )
            );
    }
}
