// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title QuantumDapp
 * @dev A decentralized quantum-resistant data storage and verification system
 * @notice This contract allows users to store quantum-secured data hashes with timestamps
 */
contract QuantumDapp {
    
    // Struct to store quantum data entries
    struct QuantumData {
        bytes32 dataHash;
        uint256 timestamp;
        address owner;
        bool isVerified;
        string metadata;
    }
    
    // Mapping from data ID to QuantumData
    mapping(uint256 => QuantumData) public quantumRecords;
    
    // Mapping to track user's data entries
    mapping(address => uint256[]) public userRecords;
    
    // Counter for data entries
    uint256 public recordCount;
    
    // Events
    event DataStored(uint256 indexed recordId, address indexed owner, bytes32 dataHash, uint256 timestamp);
    event DataVerified(uint256 indexed recordId, address indexed verifier, uint256 timestamp);
    event DataUpdated(uint256 indexed recordId, string newMetadata, uint256 timestamp);
    
    /**
     * @dev Store quantum-secured data on the blockchain
     * @param _dataHash The hash of the data to be stored
     * @param _metadata Additional metadata about the data
     * @return recordId The ID of the newly created record
     */
    function storeQuantumData(bytes32 _dataHash, string memory _metadata) public returns (uint256) {
        require(_dataHash != bytes32(0), "Invalid data hash");
        
        recordCount++;
        uint256 newRecordId = recordCount;
        
        quantumRecords[newRecordId] = QuantumData({
            dataHash: _dataHash,
            timestamp: block.timestamp,
            owner: msg.sender,
            isVerified: false,
            metadata: _metadata
        });
        
        userRecords[msg.sender].push(newRecordId);
        
        emit DataStored(newRecordId, msg.sender, _dataHash, block.timestamp);
        
        return newRecordId;
    }
    
    /**
     * @dev Verify quantum data integrity
     * @param _recordId The ID of the record to verify
     * @param _dataHash The hash to verify against stored data
     * @return bool True if verification succeeds
     */
    function verifyQuantumData(uint256 _recordId, bytes32 _dataHash) public returns (bool) {
        require(_recordId > 0 && _recordId <= recordCount, "Invalid record ID");
        require(quantumRecords[_recordId].dataHash == _dataHash, "Data verification failed");
        
        quantumRecords[_recordId].isVerified = true;
        
        emit DataVerified(_recordId, msg.sender, block.timestamp);
        
        return true;
    }
    
    /**
     * @dev Update metadata for existing quantum data
     * @param _recordId The ID of the record to update
     * @param _newMetadata New metadata string
     */
    function updateMetadata(uint256 _recordId, string memory _newMetadata) public {
        require(_recordId > 0 && _recordId <= recordCount, "Invalid record ID");
        require(quantumRecords[_recordId].owner == msg.sender, "Only owner can update metadata");
        
        quantumRecords[_recordId].metadata = _newMetadata;
        
        emit DataUpdated(_recordId, _newMetadata, block.timestamp);
    }
    
    /**
     * @dev Get all record IDs for a specific user
     * @param _user Address of the user
     * @return uint256[] Array of record IDs
     */
    function getUserRecords(address _user) public view returns (uint256[] memory) {
        return userRecords[_user];
    }
    
    /**
     * @dev Get complete details of a quantum record
     * @param _recordId The ID of the record
     * @return dataHash The stored data hash
     * @return timestamp When the data was stored
     * @return owner Address of the data owner
     * @return isVerified Verification status
     * @return metadata Additional metadata
     */
    function getQuantumRecord(uint256 _recordId) public view returns (
        bytes32 dataHash,
        uint256 timestamp,
        address owner,
        bool isVerified,
        string memory metadata
    ) {
        require(_recordId > 0 && _recordId <= recordCount, "Invalid record ID");
        
        QuantumData memory record = quantumRecords[_recordId];
        return (
            record.dataHash,
            record.timestamp,
            record.owner,
            record.isVerified,
            record.metadata
        );
    }
}
