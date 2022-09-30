// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./interfaces/IBERC721.sol";




contract Merge is ERC721, ERC721URIStorage {
    address public owner;

    string public __baseURI;
    address a;
    address b;

    event Aproove(address to, uint256 tokenId);
    event SafeTransferFrom(address from, address to, uint256 token, bytes data);
    event SafeMint(address account, uint256 tokenId);
    event Burn(address to, uint256 tokenId);

     constructor(string memory name, string memory symbol, string memory baseURI, address _a, address _b ) ERC721(name, symbol) {
        owner = msg.sender;
        __baseURI = baseURI;
        a = _a;
        b = _b;
    }

    
    modifier OnlyOwner() {
        require(msg.sender == owner, "You are not owner the contract");
        _;
    }

    function _baseURI() internal view override returns (string memory) {
        return __baseURI;
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    function burn(uint256 tokenId) public {
        emit Burn(msg.sender, tokenId);
        _burn(tokenId);
    }
    
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function approve(address to, uint256 tokenId) public override {
        address assetOwner = ERC721.ownerOf(tokenId);
        require(to != assetOwner, "ERC721: approval to current owner");

        require(
            _msgSender() == assetOwner || isApprovedForAll(assetOwner, _msgSender()),
            "ERC721: approve caller is not token owner nor approved for all"
        );
        emit Aproove( to,  tokenId);

        _approve(to, tokenId);
    }

    function safeMint(uint256 n, uint256 m) public {
        IBERC721(a).burn(n);
        IBERC721(b).burn(m);

        _safeMint(msg.sender, 1);
        emit SafeMint(msg.sender, 1);
    }

    function transferFrom(address from, address to, uint256 tokenId) public override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
        emit Transfer(msg.sender, to, tokenId);
        _transfer(from, to, tokenId);
    }

     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
        _safeTransfer(from, to, tokenId, data);
        emit SafeTransferFrom(from, to, tokenId, data);
    }
}