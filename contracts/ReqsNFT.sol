// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "./Base64.sol";

import "./CurseGenerator.sol";

contract ReqsNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 seed; 

    event CURSED(address sender, uint256 tokenId, string name, string SVG);
  
    string json1 = '{"name":"';
    string json2 = '","description":"';
    string json3 = '","image":"data:image/svg+xml;base64,';
    string json4 = '"}';

    constructor() ERC721("C U R S E S", "REQS") {
        console.log("This is my NFT contract. Woah!");
        seed = (block.timestamp + block.difficulty);
    }

    function finalData(
        string memory name,
        string memory svg
    ) public view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    json1,
                    name,
                    json2,
                    name,
                    json3,
                    svg,
                    json4
                )
            );
    }

    function GenNFT(string calldata name, string calldata description, uint256[6] calldata nb) public {

        // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();


        if(newItemId >= 50) {
            revert("No Curses Remain...");
        }

        // Actually mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newItemId);
        // Set the NFTs data.

        string memory SVG = Base64.encode(
            bytes(CurseGenerator.makeSVG(newItemId, seed, string(abi.encodePacked(name, description)), nb))
        );

        string memory meta = Base64.encode(
            bytes(finalData(name, SVG))
        );

        console.log(name);
        console.log(string(abi.encodePacked('data:image/svg+xml;base64,',SVG)));
        console.log(' - - - - - - - - - - - - - - - - ');

        _setTokenURI(newItemId, string(abi.encodePacked('data:application/json;base64,',meta)));

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();

        emit CURSED(msg.sender, newItemId, name, SVG);

    }
}
