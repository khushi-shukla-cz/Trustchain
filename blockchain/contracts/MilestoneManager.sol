// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import './CampaignManager.sol';
contract MilestoneManager {
 CampaignManager public campaigns;
 struct Milestone {uint256 campaignId;string title;string evidenceHash;uint256 amount;bool submitted;}
 Milestone[] public milestones;
 event MilestoneRequested(uint256 indexed id,uint256 indexed campaignId,uint256 amount);
 event EvidenceSubmitted(uint256 indexed id,string hash);
 constructor(address c){campaigns=CampaignManager(c);}
 function request(uint256 campaignId,string calldata title,uint256 amount) external returns(uint256){CampaignManager.Campaign memory c=campaigns.get(campaignId);require(c.ngo==msg.sender&&c.approved,'Not campaign NGO');require(amount>0,'Invalid amount');uint256 id=milestones.length;milestones.push(Milestone(campaignId,title,'',amount,false));emit MilestoneRequested(id,campaignId,amount);return id;}
 function submitEvidence(uint256 id,string calldata hash) external {Milestone storage m=milestones[id];require(campaigns.get(m.campaignId).ngo==msg.sender,'NGO only');require(bytes(hash).length>0,'Empty hash');m.evidenceHash=hash;m.submitted=true;emit EvidenceSubmitted(id,hash);}
 function count() external view returns(uint256){return milestones.length;}
}
