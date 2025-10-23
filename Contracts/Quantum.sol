// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title QuantumDapp
 * @dev A simple decentralized app for managing digital assets and recording ownership transactions.
 */

contract QuantumDapp {
    address public owner;

    struct Asset {
        uint id;
        string name;
        address creator;
        address currentOwner;
        uint createdAt;
    }

    uint public assetCount;
    mapping(uint => Asset) public assets;
    mapping(address => uint[]) public userAssets;

    event AssetCreated(uint indexed id, string name, address indexed creator);
    event OwnershipTransferred(uint indexed id, address indexed from, address indexed to);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can access this function");
        _;
    }

    /**
     * @dev Create a new digital asset
     * @param _name The name of the digital asset
     */
    function createAsset(string memory _name) public {
        assetCount++;
        assets[assetCount] = Asset(assetCount, _name, msg.sender, msg.sender, block.timestamp);
        userAssets[msg.sender].push(assetCount);
        emit AssetCreated(assetCount, _name, msg.sender);
    }

    /**
     * @dev Transfer ownership of an existing asset
     * @param _assetId The ID of the asset
     * @param _newOwner Address of the new owner
     */
    function transferOwnership(uint _assetId, address _newOwner) public {
        Asset storage asset = assets[_assetId];
        require(asset.currentOwner == msg.sender, "You are not the current owner");
        require(_newOwner != address(0), "Invalid new owner address");

        address previousOwner = asset.currentOwner;
        asset.currentOwner = _newOwner;

        userAssets[_newOwner].push(_assetId);
        emit OwnershipTransferred(_assetId, previousOwner, _newOwner);
    }

    /**
     * @dev Get details of a specific asset
     * @param _assetId The ID of the asset
     */
    function getAsset(uint _assetId)
        public
        view
        returns (string memory, address, address, uint)
    {
        Asset memory asset = assets[_assetId];
        return (asset.name, asset.creator, asset.currentOwner, asset.createdAt);
    }
}

