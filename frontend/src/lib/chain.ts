import {BrowserProvider,Contract,JsonRpcProvider,formatEther,parseEther} from 'ethers';
import deployments from './deployments.json';
export const addresses=deployments as Record<string,any>;
const rpcUrl=process.env.NEXT_PUBLIC_RPC_URL||'http://127.0.0.1:8545';
function ethereumProvider(){if(typeof window==='undefined')return null;const ethereum=(window as any).ethereum;if(ethereum?.providers?.length)return ethereum.providers.find((p:any)=>p.isMetaMask)||ethereum.providers[0];return ethereum||null}
export const ABIS:Record<string,string[]>={
AccessController:['function DEFAULT_ADMIN_ROLE() view returns(bytes32)','function NGO_ROLE() view returns(bytes32)','function REVIEWER_ROLE() view returns(bytes32)','function AUDITOR_ROLE() view returns(bytes32)','function hasRole(bytes32,address) view returns(bool)','function grant(bytes32,address)','function revoke(bytes32,address)','function pause()','function unpause()','function isPaused() view returns(bool)'],
NGORegistry:['function register(string,string)','function decide(address,bool)','function ngos(address) view returns(string,string,bool,bool,bool)','event NGORegistered(address indexed wallet,string name,string documentHash)','event NGODecided(address indexed wallet,bool approved)'],
CampaignManager:['function create(string,string,uint256,uint256) returns(uint256)','function decide(uint256,bool)','function count() view returns(uint256)','function get(uint256) view returns(tuple(address ngo,string title,string metadataURI,uint256 goal,uint256 deadline,bool approved,bool rejected))','event CampaignCreated(uint256 indexed id,address indexed ngo,string title,uint256 goal)','event CampaignDecided(uint256 indexed id,bool approved)'],
DonationEscrow:['function donate(uint256) payable','function release(uint256,uint256,address,uint256)','function refund(uint256)','function raised(uint256) view returns(uint256)','function released(uint256) view returns(uint256)','function refunded(uint256) view returns(uint256)','function balanceOf(uint256) view returns(uint256)','function contributions(uint256,address) view returns(uint256)','event Donated(uint256 indexed campaignId,address indexed donor,uint256 amount)','event Released(uint256 indexed campaignId,uint256 indexed milestoneId,address indexed recipient,uint256 amount)','event Refunded(uint256 indexed campaignId,address indexed donor,uint256 amount)'],
MilestoneManager:['function request(uint256,string,uint256) returns(uint256)','function submitEvidence(uint256,string)','function count() view returns(uint256)','function milestones(uint256) view returns(uint256 campaignId,string title,string evidenceHash,uint256 amount,bool submitted)','event MilestoneRequested(uint256 indexed id,uint256 indexed campaignId,uint256 amount)'],
GovernanceVoting:['function create(uint256) returns(uint256)','function vote(uint256,bool)','function execute(uint256)','function count() view returns(uint256)','function proposals(uint256) view returns(uint256 milestoneId,uint256 yes,uint256 no,uint256 deadline,bool executed)','function voted(uint256,address) view returns(bool)','event ProposalCreated(uint256 indexed id,uint256 indexed milestoneId)','event Voted(uint256 indexed id,address indexed voter,bool approve)'],
AuditRegistry:['function record(uint256,string,string)','function count() view returns(uint256)','function records(uint256) view returns(uint256,string,string,address,uint256)','event AuditRecorded(uint256 indexed id,uint256 indexed campaignId,string evidenceHash)']};
ABIS.ExpenseRegistry=['function record(uint256,uint256,address,uint256,string,string) returns(uint256)','function count() view returns(uint256)','function expenses(uint256) view returns(uint256,uint256,address,uint256,string,string,uint256)','function reported(uint256) view returns(uint256)','event ExpenseRecorded(uint256 indexed id,uint256 indexed campaignId,uint256 indexed milestoneId,address vendor,uint256 amount,string invoiceHash)'];
export function provider(){return new JsonRpcProvider(rpcUrl)}
export async function wallet() {
  const ethereum = ethereumProvider();

  if (!ethereum) {
    throw Error('MetaMask is not detected. Enable MetaMask and refresh.');
  }

  const p = new BrowserProvider(ethereum);
  await p.send('eth_requestAccounts', []);

  let chainId = await ethereum.request({method: 'eth_chainId'});

  if (chainId !== '0x539') {
    try {
      await ethereum.request({
        method: 'wallet_switchEthereumChain',
        params: [{chainId: '0x539'}],
      });
    } catch (e: any) {
      if (e.code !== 4902) throw e;

      await ethereum.request({
        method: 'wallet_addEthereumChain',
        params: [{
          chainId: '0x539',
          chainName: 'Ganache Local',
          nativeCurrency: {
            name: 'Test ETH',
            symbol: 'ETH',
            decimals: 18,
          },
          rpcUrls: [rpcUrl],
        }],
      });
    }

    chainId = await ethereum.request({method: 'eth_chainId'});
  }

  if (chainId !== '0x539') {
    throw Error('Please select Ganache Local, Chain ID 1337.');
  }

  await ethereum.request({method: 'eth_blockNumber'});

  return p.getSigner();
}
export async function contract(name:string,write=false){if(!addresses[name])throw Error('Deploy contracts first: npm run deploy');const p=provider();return new Contract(addresses[name],ABIS[name],write?await wallet():p)}
export async function transact(name:string,method:string,args:any[]=[],value?:string){const c=await contract(name,true);const tx=value?await c[method](...args,{value:parseEther(value)}):await c[method](...args);const receipt=await tx.wait();return {hash:tx.hash,block:receipt.blockNumber};}
export {formatEther,parseEther};
