// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBERC721 {
  function burn(uint256 tokenId,  address contractAddr) external;
  function ownerOf(address sender, uint256 tokenId) external returns  (address);
  function approve(address _to, uint256 _tokenId) external;
  function setApprovalForAll(address _operator, bool _approved) external;
}
