import hre from 'hardhat';
import process from 'process';
import { ethers } from 'ethers';

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    const fee = ethers.utils.parseUnits('10', 18);

    console.log('Deploying contracts with the account:', deployer.address);

    const Token = await hre.ethers.getContractFactory('Token');
    const token = await Token.deploy();
    console.log(`Token deployed to: ${token.address}`);

    const Staking = await hre.ethers.getContractFactory('Staking');
    const staking = await Staking.deploy(token.address);
    console.log(`Staking deployed to: ${staking.address}`);

    const Quiz = await hre.ethers.getContractFactory('Quiz');
    const quiz = await Quiz.deploy(token.address);
    console.log(`Quiz deployed to: ${quiz.address}`);

    const NFTCollection = await hre.ethers.getContractFactory('NFTCollection');
    const nftCollection = await NFTCollection.deploy();
    console.log(`NFT Collection deployed to: ${nftCollection.address}`);

    const Lottery = await hre.ethers.getContractFactory('Lottery');
    const lottery = await Lottery.deploy(token.address, nftCollection.address);
    console.log(`Lottery deployed to: ${lottery.address}`);

    const Native = await hre.ethers.getContractFactory('Native');
    const native = await Native.deploy();
    console.log(`Native deployed to: ${native.address}`);

    const TokenFactory = await hre.ethers.getContractFactory('TokenFactory');
    const tokenFactory = await TokenFactory.deploy(native.address, fee);
    console.log(`Token Factory deployed to: ${tokenFactory.address}`);

    const Leaderboard = await hre.ethers.getContractFactory('Leaderboard');
    const leaderboard = await Leaderboard.deploy();
    console.log(`Leaderboard deployed to: ${leaderboard.address}`);

    const Referral = await hre.ethers.getContractFactory('Referral');
    const referral = await Referral.deploy(token.address);
    console.log(`Referral deployed to: ${referral.address}`);

    const NameService = await hre.ethers.getContractFactory('NameService');
    const nameService = await NameService.deploy();
    console.log(`Name Service deployed to: ${nameService.address}`);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error('❌ Deployment failed:', error);
        process.exit(1);
    });
