// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {CustomErrors} from "../src/CustomErrors.sol";

contract CustomErrorsTest is Test {
    CustomErrors customErrors;

    address owner = vm.addr(0x1);
    address notOwner = vm.addr(0x2);

    function setUp() public {
        vm.prank(owner);
        customErrors = new CustomErrors();
    }
    
    /*----------Deployment----------*/

    function test_DeploymentCustomErrors() public view {
        assertEq(customErrors.owner(), owner);

    }

    /*----------SetNumber functionality----------*/
    function test_AllowValidNumber() public {
        uint256 validNumber = 16;

        vm.prank(owner);
        customErrors.setNumber(validNumber);

        assertEq(customErrors.number(), validNumber);

    }

    function test_RevertWhenNotOwner() public {
        uint256 validNumber = 16;

        vm.prank(notOwner);
        vm.expectRevert(abi.encodeWithSelector(CustomErrors.NotOwner.selector, notOwner));
        customErrors.setNumber(validNumber);
    }

    function test_RevertWhenLowNumber() public {
        uint256 invalidNumber = 2;

        vm.prank(owner);
        vm.expectRevert(abi.encodeWithSelector(CustomErrors.TooLow.selector, invalidNumber, 10));
        customErrors.setNumber(invalidNumber);
    }

    function test_NumberUnchanged() public {
        uint256 validNumber = 16;
        uint256 invalidNumber = 2;

        vm.prank(owner);
        customErrors.setNumber(validNumber);
        assertEq(customErrors.number(), validNumber);

        vm.prank(owner);
        vm.expectRevert(abi.encodeWithSelector(CustomErrors.TooLow.selector, invalidNumber, 10));
        customErrors.setNumber(invalidNumber);

        assertEq(customErrors.number(), validNumber);

    }
}