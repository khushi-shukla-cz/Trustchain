const hre=require('hardhat');const fs=require('fs');const path=require('path');
async function main(){const [owner]=await hre.ethers.getSigners();const deployed={chainId:1337};async function make(name,args=[]){const factory=await hre.ethers.getContractFactory(name);const c=await factory.deploy(...args);await c.waitForDeployment();deployed[name]=await c.getAddress();console.log(name,deployed[name]);return c;}
const access=await make('AccessController');const a=await access.getAddress();const registry=await make('NGORegistry',[a]);await(await access.grant(await access.DEFAULT_ADMIN_ROLE(),await registry.getAddress())).wait();const manager=await make('CampaignManager',[a]);const c=await manager.getAddress();const escrow=await make('DonationEscrow',[c,a]);const e=await escrow.getAddress();const milestones=await make('MilestoneManager',[c]);const m=await milestones.getAddress();const voting=await make('GovernanceVoting',[a,m,e]);await make('AuditRegistry',[a]);await make('ExpenseRegistry',[c,e]);
const reviewerRole=await access.REVIEWER_ROLE();await(await access.grant(reviewerRole,await voting.getAddress())).wait();
await(await access.grant(await access.NGO_ROLE(),owner.address)).wait();
const latestBlock=await hre.ethers.provider.getBlock('latest');const deadline=(latestBlock?.timestamp||Math.floor(Date.now()/1000))+30*24*60*60;
const mockCampaigns=[
 ['Clean Water Initiative','ipfs://trustchain/mock-clean-water',hre.ethers.parseEther('10'),hre.ethers.parseEther('3')],
 ['Rural Education Fund','ipfs://trustchain/mock-rural-education',hre.ethers.parseEther('15'),hre.ethers.parseEther('6')],
 ['Community Health Clinic','ipfs://trustchain/mock-health-clinic',hre.ethers.parseEther('20'),hre.ethers.parseEther('9')]
 ];
for(const [title,uri,goal,donation] of mockCampaigns){const tx=await manager.create(title,uri,goal,deadline);await tx.wait();const id=(await manager.count())-1n;await(await manager.decide(id,true)).wait();await(await escrow.donate(id,{value:donation})).wait();console.log(`Mock campaign #${id} approved and funded with ${hre.ethers.formatEther(donation)} ETH: ${title}`);}
const out=path.join(__dirname,'../../frontend/src/lib/deployments.json');fs.mkdirSync(path.dirname(out),{recursive:true});fs.writeFileSync(out,JSON.stringify(deployed,null,2));console.log('Saved frontend deployments',out);
}main().catch(e=>{console.error(e);process.exitCode=1});
