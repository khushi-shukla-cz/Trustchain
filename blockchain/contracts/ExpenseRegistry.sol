// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import './CampaignManager.sol';

interface ExpenseEscrow {
    function released(uint256 campaignId) external view returns (uint256);
}

contract ExpenseRegistry {
    CampaignManager public campaigns;
    ExpenseEscrow public escrow;

    struct Expense {
        uint256 campaignId;
        uint256 milestoneId;
        address vendor;
        uint256 amount;
        string purpose;
        string invoiceHash;
        uint256 timestamp;
    }

    Expense[] public expenses;
    mapping(uint256 => uint256) public reported;

    event ExpenseRecorded(
        uint256 indexed id,
        uint256 indexed campaignId,
        uint256 indexed milestoneId,
        address vendor,
        uint256 amount,
        string invoiceHash
    );

    constructor(address campaignManager, address escrowAddress) {
        campaigns = CampaignManager(campaignManager);
        escrow = ExpenseEscrow(escrowAddress);
    }

    function record(
        uint256 campaignId,
        uint256 milestoneId,
        address vendor,
        uint256 amount,
        string calldata purpose,
        string calldata invoiceHash
    ) external returns (uint256) {
        CampaignManager.Campaign memory campaign = campaigns.get(campaignId);
        require(campaign.ngo == msg.sender, 'Campaign NGO only');
        require(campaign.approved, 'Campaign inactive');
        require(vendor != address(0) && amount > 0, 'Invalid expense');
        require(bytes(purpose).length > 0 && bytes(invoiceHash).length > 0, 'Details required');
        require(reported[campaignId] + amount <= escrow.released(campaignId), 'Exceeds released funds');

        uint256 id = expenses.length;
        expenses.push(Expense(campaignId, milestoneId, vendor, amount, purpose, invoiceHash, block.timestamp));
        reported[campaignId] += amount;
        emit ExpenseRecorded(id, campaignId, milestoneId, vendor, amount, invoiceHash);
        return id;
    }

    function count() external view returns (uint256) {
        return expenses.length;
    }
}
