// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MultiTypeNFT is ERC721, Ownable {
    using Counters for Counters.Counter;

    // Counter for token IDs
    Counters.Counter private _tokenIdCounter;

    // Struct to hold NFT type information
    struct NFTType {
        uint256 typeId;
        string name;
        string metadataURI;
        uint256 maxSupply;
        uint256 currentSupply;
        bool exists;
    }

    // Mapping from type ID to NFTType
    mapping(uint256 => NFTType) public nftTypes;

    // Mapping from token ID to its type
    mapping(uint256 => uint256) public tokenIdToType;

    // Event emitted when a new NFT type is created
    event NFTTypeCreated(
        uint256 indexed typeId,
        string name,
        string metadataURI,
        uint256 maxSupply
    );

    // Event emitted when NFTs are minted
    event NFTsMinted(
        uint256 indexed typeId,
        address indexed to,
        uint256[] tokenIds,
        uint256 quantity
    );

    constructor() ERC721("MultiTypeNFT", "MTNFT") Ownable(msg.sender) {}

 
    function createNFTType(
        uint256 typeId,
        string memory name,
        string memory metadataURI,
        uint256 maxSupply
    ) external onlyOwner {
        require(!nftTypes[typeId].exists, "NFT type already exists");

        nftTypes[typeId] = NFTType({
            typeId: typeId,
            name: name,
            metadataURI: metadataURI,
            maxSupply: maxSupply,
            currentSupply: 0,
            exists: true
        });

        emit NFTTypeCreated(typeId, name, metadataURI, maxSupply);
    }

    /**
     * @dev Mints one or more NFTs of a specific type
     * @param typeId The type of NFT to mint
     * @param to The address to receive the minted NFTs
     * @param quantity Number of NFTs to mint
     */
    function mintNFTs(
        uint256 typeId,
        address to,
        uint256 quantity
    ) external onlyOwner {
        require(nftTypes[typeId].exists, "NFT type does not exist");
        require(quantity > 0, "Quantity must be at least 1");

        NFTType storage nftType = nftTypes[typeId];

        // Check supply constraints if maxSupply is set (>0)
        if (nftType.maxSupply > 0) {
            require(
                nftType.currentSupply + quantity <= nftType.maxSupply,
                "Exceeds maximum supply for this NFT type"
            );
        }

        uint256[] memory mintedTokenIds = new uint256[](quantity);

        for (uint256 i = 0; i < quantity; i++) {
            _tokenIdCounter.increment();
            uint256 newTokenId = _tokenIdCounter.current();

            _safeMint(to, newTokenId);
            tokenIdToType[newTokenId] = typeId;
            nftType.currentSupply++;

            mintedTokenIds[i] = newTokenId;
        }

        emit NFTsMinted(typeId, to, mintedTokenIds, quantity);
    }

    /**
     * @dev Returns the metadata URI for a given token ID
     * @param tokenId The token ID to query
     * @return The metadata URI string
     */

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            ownerOf(tokenId) != address(0),
            "ERC721Metadata: URI query for nonexistent token"
        );

        uint256 typeId = tokenIdToType[tokenId];
        return nftTypes[typeId].metadataURI;
    }

  
    function getNFTTypeInfo(uint256 typeId)
        external
        view
        returns (
            string memory name,
            string memory metadataURI,
            uint256 maxSupply,
            uint256 currentSupply
        )
    {
        require(nftTypes[typeId].exists, "NFT type does not exist");
        NFTType storage nftType = nftTypes[typeId];
        return (
            nftType.name,
            nftType.metadataURI,
            nftType.maxSupply,
            nftType.currentSupply
        );
    }
}
