// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import './AccessController.sol';
contract CampaignManager {
 AccessController public access;
 struct Campaign {address ngo; string title; string metadataURI; uint256 goal; uint256 deadline; bool approved; bool rejected;}
 Campaign[] private campaigns;
 event CampaignCreated(uint256 indexed id,address indexed ngo,string title,uint256 goal);
 event CampaignDecided(uint256 indexed id,bool approved);
 constructor(address a){access=AccessController(a);}
 function create(string calldata title,string calldata uri,uint256 goal,uint256 deadline) external returns(uint256){require(access.hasRole(access.NGO_ROLE(),msg.sender),'Verified NGO only');require(goal>0&&deadline>block.timestamp,'Invalid campaign');uint256 id=campaigns.length;campaigns.push(Campaign(msg.sender,title,uri,goal,deadline,false,false));emit CampaignCreated(id,msg.sender,title,goal);return id;}
 function decide(uint256 id,bool approved) external {require(access.hasRole(access.DEFAULT_ADMIN_ROLE(),msg.sender),'Admin only');Campaign storage c=campaigns[id];require(!c.approved&&!c.rejected,'Already decided');c.approved=approved;c.rejected=!approved;emit CampaignDecided(id,approved);}
 function get(uint256 id) external view returns(Campaign memory){return campaigns[id];}
 function count() external view returns(uint256){return campaigns.length;}
}
