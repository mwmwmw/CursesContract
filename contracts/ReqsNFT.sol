// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "./Base64.sol";

contract ReqsNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event CURSED(address sender, uint256 tokenId, string name, string description);

    uint256 private seed;

    string svg1 =
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 1024 1024"><pattern id="waveform" patternUnits="userSpaceOnUse" width="100" height="100" transform-origin="512 512" patternTransform="rotate(';
    string svg2 =
        ') scale(0.25)"><g id="poly" stroke="#00FF55" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="transparent"><polyline points="';
    string svg3 =
        '"></polyline></g></pattern><rect x="0" y="0" class="st0" width="1024" height="1024" fill="#ff0055" /><rect x="0" y="0" class="st0" width="1024" height="1024" fill="url(#waveform)" transform="scale(';
    string svg4 = ')" /></svg>';

    string json1 = '{"name":"';
    string json2 = '","description":"';
    string json3 = '","image":"data:image/svg+xml;base64,';
    string json4 = '"}';

    constructor() ERC721("ReqsNFT", "SQUARE") {
        console.log("This is my NFT contract. Woah!");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function random(
        uint256 tokenId,
        uint256 mod,
        uint256 min
    ) public view returns (string memory) {
        uint256 rand = random(
            string(
                abi.encodePacked(
                    seed,
                    block.timestamp,
                    Strings.toString(tokenId)
                )
            )
        );
        rand = rand % mod;
        return Strings.toString(min + rand);
    }

    function randomDigits(uint256 tokenId, uint256 amount)
        public
        returns (string memory)
    {
        string memory prev;

        for (uint256 i; i < amount; i++) {
            seed = (block.difficulty + block.timestamp + seed);
            prev = string(
                abi.encodePacked(
                    prev,
                    Strings.toString(i),
                    ",",
                    random(tokenId, 100, 0),
                    ","
                )
            );
        }
        return prev;
    }

    function randomSVG(uint256 tokenId, string memory digits)
        public
        view
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    svg1,
                    random(tokenId, 360, 0),
                    svg2,
                    digits,
                    svg3,
                    random(tokenId, 5, 1),
                    svg4
                )
            );
    }

    function finalData(
        string memory name,
        string memory description,
        string memory svg
    ) public view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    json1,
                    name,
                    json2,
                    description,
                    json3,
                    svg,
                    json4
                )
            );
    }

    function GenNFT(string memory name, string memory description) public {
        // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();
        // Actually mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newItemId);
        // Set the NFTs data.

        string memory SVG = Base64.encode(
            bytes(randomSVG(newItemId, randomDigits(newItemId, 100)))
        );

        string memory meta = Base64.encode(
            bytes(finalData(name, description, SVG))
        );

        _setTokenURI(newItemId, string(abi.encodePacked('data:application/json;base64,',meta)));

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();

        emit CURSED(msg.sender, newItemId, name, description);

    }
}
