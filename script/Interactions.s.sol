// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingconfig() public returns (uint256, address) {
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
        createSubscriptionUsingconfig();
    }
}

contract FundSubscription is Script {
    uint256 public constant FUND_AMMOUNT = 3 ether;

    function fundSubscriptionUsingconfig() public {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
        uint256 subscriptionId = helperConfig.getConfig().subscriptionId;
    }

    function run() public {}
}
