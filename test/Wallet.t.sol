// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";

contract WalletTest is Test {
    event DepositMade(address indexed accountAddress, uint amount);
    event WithdrawalMade(address indexed accountAddress, uint amount);
    event FallbackCalled(address indexed accountAddress);

    Wallet wallet;

    address user = vm.addr(0x1);

    function setUp() public {
        wallet = new Wallet();
        vm.deal(user, 100 ether); // Tilldela user 100 ether för testning
    }

    /*----------Deposit function----------*/

    function test_DepositFunction() public {
        uint256 depositAmount = 1 ether;

        vm.expectEmit(true, false, false, true);
        emit DepositMade(user, depositAmount);
        
        vm.prank(user);
        wallet.deposit{value: depositAmount}();

        assertEq(wallet.contractBalance(), depositAmount);
    }

    function test_ReceiveFunction() public {
        uint256 depositAmount = 1 ether;

        vm.expectEmit(true, false, false, true);
        emit DepositMade(user, depositAmount);

        vm.prank(user);
        (bool success,) = address(wallet).call{value: depositAmount}("");
        assertTrue(success, "Receive function failed!");

        assertEq(wallet.contractBalance(), depositAmount);

    }

    /*----------Withdraw function----------*/

    function test_ValidWithdrawal() public {
        uint256 depositAmount = 1 ether;
        uint256 withdrawalAmount = 0.5 ether;

        vm.prank(user);
        wallet.deposit{value: depositAmount}();
        assertEq(wallet.contractBalance(), depositAmount);

        vm.expectEmit(true, false, false, true);
        emit WithdrawalMade(user, withdrawalAmount);

        vm.prank(user);
        wallet.withdrawal(withdrawalAmount);

        assertEq(wallet.contractBalance(), depositAmount - withdrawalAmount);
    }

    function test_InvalidWithdrawal() public {
        uint256 depositAmount = 5 ether;
        uint256 withdrawalAmount = 2 ether;

        vm.prank(user);
        wallet.deposit{value: depositAmount}();
        assertEq(wallet.contractBalance(), depositAmount);

        vm.prank(user);
        vm.expectRevert(bytes("You cannot withdraw more than 1 ETH per transaction"));
        wallet.withdrawal(withdrawalAmount);
    }

    /*----------Fallback function----------*/

    function test_FallbackFunction() public {
        vm.prank(user);
        vm.expectRevert(bytes("Fallback function called. This function does not exist. Try another one."));
        (bool success,) = address(wallet).call(hex"1234");
    }
}
