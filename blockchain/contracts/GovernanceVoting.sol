// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import './AccessController.sol';
import './MilestoneManager.sol';
import './DonationEscrow.sol';
contract GovernanceVoting {
 AccessController public access;MilestoneManager public milestones;DonationEscrow public escrow;
 struct Proposal {uint256 milestoneId;uint256 yes;uint256 no;uint256 deadline;bool executed;}
 Proposal[] public proposals;
 mapping(uint256=>mapping(address=>bool)) public voted;
 uint256 public threshold=2;
 event ProposalCreated(uint256 indexed id,uint256 indexed milestoneId);
 event Voted(uint256 indexed id,address indexed voter,bool approve);
 event Executed(uint256 indexed id);
 constructor(address a,address m,address e){access=AccessController(a);milestones=MilestoneManager(m);escrow=DonationEscrow(payable(e));}
 function create(uint256 milestoneId) external returns(uint256){(uint256 campaignId,,,uint256 amount,bool submitted)=milestones.milestones(milestoneId);require(submitted&&amount>0,'Evidence required');require(access.hasRole(access.REVIEWER_ROLE(),msg.sender),'Reviewer only');uint256 id=proposals.length;proposals.push(Proposal(milestoneId,0,0,block.timestamp+1 days,false));emit ProposalCreated(id,milestoneId);return id;}
 function vote(uint256 id,bool approve) external {require(access.hasRole(access.REVIEWER_ROLE(),msg.sender),'Reviewer only');Proposal storage p=proposals[id];require(block.timestamp<p.deadline&&!p.executed,'Voting closed');require(!voted[id][msg.sender],'Already voted');voted[id][msg.sender]=true;if(approve)p.yes++;else p.no++;emit Voted(id,msg.sender,approve);}
 function execute(uint256 id) external {Proposal storage p=proposals[id];require(!p.executed&&p.yes>=threshold,'Not approved');(uint256 campaignId,,,uint256 amount,bool submitted)=milestones.milestones(p.milestoneId);require(submitted,'Missing evidence');p.executed=true;CampaignManager manager=CampaignManager(address(escrow.campaigns()));CampaignManager.Campaign memory campaign=manager.get(campaignId);address ngo=campaign.ngo;escrow.release(campaignId,p.milestoneId,payable(ngo),amount);emit Executed(id);}
 function count() external view returns(uint256){return proposals.length;}
}
