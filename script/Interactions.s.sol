// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {HelperConfig, Constant} from "script/HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "test/mocks/LinkToken.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint256, address) {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
        (uint256 subId, ) = createSubscription(vrfCoordinator);
        return (subId, vrfCoordinator);
    }

    function createSubscription(
        address _vrfCoordinator
    ) public returns (uint256, address) {
        console2.log("Creating subscription on chain Id:", block.chainid);
        vm.startBroadcast();
        uint256 subId = VRFCoordinatorV2_5Mock(_vrfCoordinator)
            .createSubscription();
        vm.stopBroadcast();

        console2.log("Your subscription Id is:", subId);
        console2.log(
            "Please update the subscription Id in your HelperConfig file"
        );
        return (subId, _vrfCoordinator);
    }

    function run() public {
        createSubscriptionUsingConfig();
    }
}

contract FundSubscription is Script, Constant {
    uint256 public constant FUND_AMMOUNT = 3 ether;

    function fundSubscriptionUsingConfig() public {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
        uint256 subscriptionId = helperConfig.getConfig().subscriptionId;
        address linkToken = helperConfig.getConfig().link;
        fundSubscription(vrfCoordinator, subscriptionId, linkToken);
    }

    function fundSubscription(
        address _vrfCoordinator,
        uint256 _subscriptionId,
        address _linkToken
    ) public {
        console2.log("Funding subscription: ", _subscriptionId);
        console2.log("Using VRF Coordinator: ", _vrfCoordinator);
        console2.log("On ChainId: ", _linkToken);

        if (block.chainid == LOCAL_CHAIN_ID) {
            vm.startBroadcast();
            VRFCoordinatorV2_5Mock(_vrfCoordinator).fundSubscription(
                _subscriptionId,
                FUND_AMMOUNT
            );
            vm.stopBroadcast();
        } else {
            vm.startBroadcast();
            LinkToken(_linkToken).transferAndCall(
                _vrfCoordinator,
                FUND_AMMOUNT,
                abi.encode(_subscriptionId)
            );
            vm.stopBroadcast();
        }
    }

    function run() public {
        fundSubscriptionUsingConfig();
    }
}

contract AddConsumer is Script {
    function addConsumerUsingConfig(address _mostRecentlyDeployed) public {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
        uint256 subscriptionId = helperConfig.getConfig().subscriptionId;
        addConsumer(_mostRecentlyDeployed, vrfCoordinator, subscriptionId);
    }

    function addConsumer(
        address _contractToAddToVrf,
        address _vrfCoordinator,
        uint256 _subscriptionId
    ) public {
        console2.log("Adding consumer contract: ", _contractToAddToVrf);
        console2.log("To VRF Coordinator: ", _vrfCoordinator);
        console2.log("On ChainId: ", block.chainid);

        vm.startBroadcast();
        VRFCoordinatorV2_5Mock(_vrfCoordinator).addConsumer(
            _subscriptionId,
            _contractToAddToVrf
        );
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "Raffle",
            block.chainid
        );
        addConsumerUsingConfig(mostRecentlyDeployed);
    }
}
