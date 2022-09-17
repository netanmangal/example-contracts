// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

contract ProofOfExistence3 {

  mapping (bytes32 => bool) private proofs;
  
  // store a proof of existence in the contract state
  function storeProof(bytes32 proof) 
    internal 
  {
    proofs[proof] = true;
  }
  
  // calculate and store the proof for a document
  function notarize(string memory document) 
    public 
  { 
    storeProof( proofFor(document) );
  }
  
  // helper function to get a document's keccak256 hash
  function proofFor(string memory document) 
    pure 
    private 
    returns (bytes32) 
  {
    return sha256 ( abi.encodePacked(document) );
  }
  
  // check if a document has been notarized
  function checkDocument(string memory document) 
    public 
    view 
    returns (bool) 
  {
    return hasProof( proofFor(document) );
  }

  // returns true if proof is stored
  function hasProof(bytes32 proof) 
    internal 
    view 
    returns(bool) 
  {
    return proofs[proof];
  }
}
