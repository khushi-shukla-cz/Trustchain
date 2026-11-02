// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import '@openzeppelin/contracts/access/AccessControl.sol';
import '@openzeppelin/contracts/utils/Pausable.sol';
contract AccessController is AccessControl, Pausable {
 bytes32 public constant NGO_ROLE=keccak256('NGO_ROLE');
 bytes32 public constant AUDITOR_ROLE=keccak256('AUDITOR_ROLE');
 bytes32 public constant REVIEWER_ROLE=keccak256('REVIEWER_ROLE');
 constructor(){_grantRole(DEFAULT_ADMIN_ROLE,msg.sender);_grantRole(REVIEWER_ROLE,msg.sender);_grantRole(AUDITOR_ROLE,msg.sender);}
 function grant(bytes32 role,address account) external onlyRole(DEFAULT_ADMIN_ROLE){_grantRole(role,account);}
 function revoke(bytes32 role,address account) external onlyRole(DEFAULT_ADMIN_ROLE){_revokeRole(role,account);}
 function pause() external onlyRole(DEFAULT_ADMIN_ROLE){_pause();}
 function unpause() external onlyRole(DEFAULT_ADMIN_ROLE){_unpause();}
 function isPaused() external view returns(bool){return paused();}
}
