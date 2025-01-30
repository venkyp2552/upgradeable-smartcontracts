// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "lib/forge-std/src/Test.sol";
import {DeployBox} from "../script/DeployBox.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {UpgradeBox} from "../script/UpgradeBox.sol";

contract DeployAndUpgradeTest is Test{
    DeployBox public deployer;
    UpgradeBox public upgrader;
    BoxV1 public boxv1;
    address public OWNER=makeAddr('owner');
    address public proxy;

    function setUp() public {
        deployer=new DeployBox();
        upgrader=new UpgradeBox();
        proxy=deployer.run(); //right now point to boxv1
    }

    function testProxyStartAsBox1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(7);

    }


    function testUpgrades() public{
        BoxV2 boxv2=new BoxV2();
        upgrader.upgradeBox(proxy,address(boxv2));

        uint256 expectedValue=2;
        assertEq(expectedValue,BoxV2(proxy).version());


        BoxV2(proxy).setNumber(7);
        assertEq(7,BoxV2(proxy).getValue());
    }


}