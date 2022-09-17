// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

contract ProofOfExistence2 {

  // state
  bytes32[] private proofs;

  // store a proof of existence in the contract state
  // *transactional function*
  function storeProof(bytes32 proof) 
    public 
  {
    proofs.push( proof );
  }

  // calculate and store the proof for a document
  // *transactional function*
  function notarize(string calldata document) 
    external 
  {
    storeProof ( proofFor(document) );
  }

  // helper function to get a document's sha256
  // *read-only function*
  function proofFor(string memory document) 
    pure 
    public 
    returns (bytes32) 
  {
    return sha256 ( abi.encodePacked(document) );
  }

  // check if a document has been notarized
  // *read-only function*
  function checkDocument(string memory document) 
    public 
    view 
    returns (bool) 
  {
    return hasProof( proofFor(document) );
  }

  // returns true if proof is stored
  // *read-only function*
  function hasProof(bytes32 proof) 
    internal 
    view 
    returns (bool) 
  {
    uint256 length = proofs.length;
    for (uint256 i = 0; i < length; i++) {
      if (proof == proofs[i]) {
        return true;
      }
    }

    return false;
  }
}
