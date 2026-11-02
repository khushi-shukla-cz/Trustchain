// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import './AccessController.sol';
contract NGORegistry {
 AccessController public access;
 struct NGO {string name; string documentHash; bool exists; bool verified; bool rejected;}
 mapping(address=>NGO) public ngos;
 event NGORegistered(address indexed wallet,string name,string documentHash);
 event NGODecided(address indexed wallet,bool approved);
 constructor(address a){access=AccessController(a);}
 function register(string calldata name,string calldata documentHash) external {require(bytes(name).length>0,'Name required');require(!ngos[msg.sender].exists,'Already registered');ngos[msg.sender]=NGO(name,documentHash,true,false,false);emit NGORegistered(msg.sender,name,documentHash);}
 function decide(address wallet,bool approved) external {require(access.hasRole(access.DEFAULT_ADMIN_ROLE(),msg.sender),'Admin only');require(ngos[wallet].exists,'Unknown NGO');ngos[wallet].verified=approved;ngos[wallet].rejected=!approved;if(approved){access.grant(access.NGO_ROLE(),wallet);}else if(access.hasRole(access.NGO_ROLE(),wallet)){access.revoke(access.NGO_ROLE(),wallet);}emit NGODecided(wallet,approved);}
 function isVerified(address wallet) external view returns(bool){return ngos[wallet].verified;}
}
