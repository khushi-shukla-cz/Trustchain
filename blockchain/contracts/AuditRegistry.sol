// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import './AccessController.sol';
contract AuditRegistry {
 AccessController public access;
 struct Record {uint256 campaignId;string evidenceHash;string finding;address auditor;uint256 timestamp;}
 Record[] public records;
 event AuditRecorded(uint256 indexed id,uint256 indexed campaignId,string evidenceHash);
 constructor(address a){access=AccessController(a);}
 function record(uint256 campaignId,string calldata evidenceHash,string calldata finding) external {require(access.hasRole(access.AUDITOR_ROLE(),msg.sender),'Auditor only');uint256 id=records.length;records.push(Record(campaignId,evidenceHash,finding,msg.sender,block.timestamp));emit AuditRecorded(id,campaignId,evidenceHash);}
 function count() external view returns(uint256){return records.length;}
}
