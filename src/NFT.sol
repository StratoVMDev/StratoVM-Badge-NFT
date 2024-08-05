// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin-contracts-5.0.2/token/ERC721/ERC721.sol";
import "@openzeppelin-contracts-5.0.2/access/Ownable.sol";

contract NFT is ERC721,Ownable {

    error AlreadyMintedInEpoch();
    error Paused();

string public URI="";
uint private tokenIdCount;
bool public paused;

mapping(address => uint256) public lastMinted;

modifier isPaused() {
    if (paused==true) {
        revert Paused();
    }
    _;
}

    
constructor(address initialOwner,string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
        Ownable(initialOwner)
    {}

    function mint() external isPaused {
        if (block.timestamp < 1 days + lastMinted[msg.sender]) {
            revert AlreadyMintedInEpoch();
        } else {
            lastMinted[msg.sender]=block.timestamp;
            tokenIdCount++;
            _mint(msg.sender,tokenIdCount);
        }
    }

    // The following functions are overrides required by Solidity.

    function tokenURI(uint256 tokenId) public view override returns (string memory) {

        return URI;
    }

    function setURI(string memory _newuri) external onlyOwner {
        URI=_newuri;
    }

    function setPause() external onlyOwner() {
        paused=!paused;
    }

}