// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./ICurses.sol";

import "hardhat/console.sol";

contract ReqsNFT is ERC721, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(uint256 => ICurses.Curse) curses;
    uint256 price = 5000000000000000;

    address public renderingContractAddress;

    event CURSED(address sender, uint256 tokenId, string name);

    constructor() ERC721("C U R S E S", "REQS") {}

    function GenNFT(
        string calldata curseName,
        string calldata description,
        uint256[6] calldata magic
    ) public payable virtual {
        require(msg.value >= price, "Not enough ETH sent; check price!");
        // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();

        if (newItemId >= 10000) {
            revert("The magic power has faded...");
        }

        ICurses.Curse memory curse;

        curse.name = curseName;
        curse.description = description;
        curse.magic = magic;

        curse.seed = uint256(
            keccak256(
                abi.encodePacked(
                    newItemId,
                    msg.sender,
                    block.difficulty,
                    block.timestamp
                )
            )
        );

        _safeMint(msg.sender, newItemId);

        curses[newItemId] = curse;

        emit CURSED(msg.sender, newItemId, curseName);

        _tokenIds.increment();
    }

    function setRenderingContractAddress(address _renderingContractAddress)
        public
        onlyOwner
    {
        renderingContractAddress = _renderingContractAddress;
    }

    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }

    function totalCurses() public view virtual returns (uint256) {
        return _tokenIds.current();
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (renderingContractAddress == address(0)) {
            return "";
        }

        ICurseRenderer renderer = ICurseRenderer(renderingContractAddress);
        return renderer.tokenURI(_tokenId, curses[_tokenId]);
    }

    receive() external payable {}

    function withdraw() public onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }
}
