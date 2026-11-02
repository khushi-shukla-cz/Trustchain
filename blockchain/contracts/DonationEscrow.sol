// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
import './CampaignManager.sol';
import './AccessController.sol';
contract DonationEscrow is ReentrancyGuard {
 CampaignManager public campaigns; AccessController public access;
 mapping(uint256=>mapping(address=>uint256)) public contributions;
 mapping(uint256=>uint256) public raised;
 mapping(uint256=>uint256) public released;
 mapping(uint256=>uint256) public refunded;
 mapping(uint256=>mapping(uint256=>bool)) public milestonePaid;
 event Donated(uint256 indexed campaignId,address indexed donor,uint256 amount);
 event Released(uint256 indexed campaignId,uint256 indexed milestoneId,address indexed recipient,uint256 amount);
 event Refunded(uint256 indexed campaignId,address indexed donor,uint256 amount);
 constructor(address c,address a){campaigns=CampaignManager(c);access=AccessController(a);}
 function donate(uint256 id) external payable nonReentrant {CampaignManager.Campaign memory c=campaigns.get(id);require(!access.isPaused(),'Paused');require(c.approved&&!c.rejected,'Not approved');require(block.timestamp<c.deadline,'Expired');require(msg.value>0,'Zero donation');contributions[id][msg.sender]+=msg.value;raised[id]+=msg.value;emit Donated(id,msg.sender,msg.value);}
 function balanceOf(uint256 id) public view returns(uint256){return raised[id]-released[id]-refunded[id];}
 function release(uint256 id,uint256 milestoneId,address payable recipient,uint256 amount) external nonReentrant {require(!access.isPaused(),'Paused');require(access.hasRole(access.REVIEWER_ROLE(),msg.sender),'Reviewer only');CampaignManager.Campaign memory c=campaigns.get(id);require(c.approved,'Inactive');require(!milestonePaid[id][milestoneId],'Milestone already paid');require(amount>0&&amount<=balanceOf(id),'Insufficient escrow');require(recipient==c.ngo,'Recipient must be NGO');milestonePaid[id][milestoneId]=true;released[id]+=amount;(bool ok,)=recipient.call{value:amount}('');require(ok,'Transfer failed');emit Released(id,milestoneId,recipient,amount);}
 function refund(uint256 id) external nonReentrant {CampaignManager.Campaign memory c=campaigns.get(id);require(block.timestamp>=c.deadline,'Not expired');require(raised[id]<c.goal,'Goal met');require(released[id]==0,'Funds already released');uint256 amount=contributions[id][msg.sender];require(amount>0,'No refund');contributions[id][msg.sender]=0;refunded[id]+=amount;(bool ok,)=payable(msg.sender).call{value:amount}('');require(ok,'Refund failed');emit Refunded(id,msg.sender,amount);}
}
