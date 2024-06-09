// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MicoMod4Token is ERC20 {
    address public owner;

    constructor() ERC20("MicoMod4Token", "MM4") {
        owner = msg.sender;
    }
    mapping(address => mapping(string => uint256)) public playerNFTs;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    event NFTMinted(address indexed player, string nft, uint256 amount);
    event TokensBurned(address indexed player, uint256 amount);
    event TokensTransferred(address indexed from, address indexed to, uint256 amount);

    // Mint
    function MicoMod4TokenMint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // Redeem
    function MicoMod4TokenRedeem(address player, string memory nft, uint256 amount) public {
        uint256 tokensRequired = 100;
        uint256 nftsToMint = amount / tokensRequired;
        require(balanceOf(player) >= amount, "Insufficient token balance");
        require(nftsToMint > 0, "Insufficient tokens to redeem for NFTs");

        // NFTs
        require(
            keccak256(abi.encodePacked(nft)) == keccak256(abi.encodePacked("AXS")) ||
            keccak256(abi.encodePacked(nft)) == keccak256(abi.encodePacked("SLP")) ||
            keccak256(abi.encodePacked(nft)) == keccak256(abi.encodePacked("DogeCoin")),
            "Invalid NFT name"
        );

        playerNFTs[player][nft] += nftsToMint;
        _burn(player, amount);

        emit NFTMinted(player, nft, nftsToMint);
    }

    // Burn 
    function MicoMod4TokenBurn(address player, uint256 amount) external {
        _burn(player, amount);
        emit TokensBurned(player, amount);
    }

    // Transfer
    function MicoMod4TokenTransfer(address from, address to, uint256 amount) public {
        _transfer(from, to, amount);
        emit TokensTransferred(from, to, amount);
    }

    // NFTS Balance  
    function MicoMod4TokenGetNFTBalance(address player, string memory nft) public view returns (uint256) {
        return playerNFTs[player][nft];
    }
}

