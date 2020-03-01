## Solidity Wargame -

Based on OpenZeppelin's Ethernaut: https://ethernaut.zeppelin.solutions/

This WarGame was inspired by OpenZeppelin's Ethernaut WarGame. The goal of this WarGame is to assess the ability of the challenger to assess and use live contracts on a test network (Ropsten), as well as identify vulnerabilities in deployed contracts which can be exploited to achieve objectives.

Testnet Ether (Ropsten) is required for this WarGame. If you do not have REth, use this faucet: https://faucet.metamask.io/

Level instances are deployed with the help of a central contract:

Use this contract to receive challenges. There are 6 levels in total. Challenges can be completed in any order, although they generally increase in difficulty with the ascending level number.

Challenges can be started by calling "getChallenge(uint index)" in WarGame.sol. It is recommended that challengers start from level 0, and work their way through level 6. "getChallenge(uint index)" will replace the sender's current challenge, but if the current challenge is complete and verified, "getChallenge(uint index)" will add the completed challenge to the sender's "completed_challenges" mapping. Challengers can use the central contract's "current_challenge" mapping to keep track of information regarding their current active challenge. If a challenger has finished every level, "getChallenge(uint index)" will set the sender's "total_completion" mapping to true. All challenge contracts, as well as the central contract (and their deploy locations), are located in the EthereumAuthio github: https://github.com/EthereumAuthio/wargame

The main WarGame contract, through which challenge instances are deployd, is located here: https://ropsten.etherscan.io/address/0x6Dd70b6a8AE5d1238436BE0c342A0FC5ff327c7d

=========================

LEVELS:

=========================

#### Level 00 - "Force" (from OpenZeppelin's Ethernaut):

Objectives--
1. Force the deployed contract's balance above 0

#### Level 01 - "King" (from OpenZeppelin's Ethernaut):

Objectives:
1. Become king, while preventing the owner from reclaiming kingship

#### Level 02 - "Elevator" (from OpenZeppelin's Ethernaut):

Objectives:
1. Reach the top floor of the building with the Elevator (set top to true)

#### Level 03 - "No Refunds":

Objectives:
1. Steal the contract's token balance (10000) and award it to yourself

#### Level 04 - "Psychic":

Objectives:
1. Become psychic - set your is_psychic mapping to true.

#### Level 05 - "Hostile Takeover":

Objectives:
1. Remove the contract deployer's "is_owner" status
2. Blacklist the contract deployer
3. Set yourself as an owner
