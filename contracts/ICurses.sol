// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

interface ICurses {
    struct Curse {
        string name;
        string description;
        uint256[6] magic;
        uint256 seed;
    }
}


interface ICurseRenderer {
    function tokenURI(uint256 tokenId, ICurses.Curse memory curse) external view returns (string memory);
}