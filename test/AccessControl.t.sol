// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {AccessControl} from "../src/AccessControl.sol";

contract AccessControlTest is Test {
    event RoleAssigned(address indexed account, string role);

    AccessControl accessControl;

    address owner = vm.addr(0x1);
    address admin = vm.addr(0x2);
    address supporter = vm.addr(0x3);
    address member = vm.addr(0x4);

    function setUp() public {
        vm.prank(owner);
        accessControl = new AccessControl();
    }

    /*----------Deployment----------*/

    function test_Deployment() public view {
        // Owner är den som har deployat kontraktet
        // Vi vill säkerställa att mappingen admins för vår owner är true
        assertTrue(accessControl.admins(owner));
    }

    /*----------Assign role tests----------*/

    function test_AssignAdminRole() public {
        // Vi förväntar oss att admin inte har rollen innan den tilldelas
        assertFalse(accessControl.admins(admin));

        vm.expectEmit(true, false, false, true);

        emit RoleAssigned(admin, "Admin");

        vm.prank(owner);
        accessControl.assignAdminRole(admin);

        assertTrue(accessControl.admins(admin));
    }

    function test_AssingSupRole() public {
        assertFalse(accessControl.supporters(supporter));

        vm.expectEmit(true, false, false, true);

        emit RoleAssigned(supporter, "Supporter");

        vm.prank(owner);
        accessControl.assignOtherRole(supporter, "Supporter");

        assertTrue(accessControl.supporters(supporter));
    }

    function test_AssingMemberRole() public {
        assertFalse(accessControl.members(member));

        vm.expectEmit(true, false, false, true);

        emit RoleAssigned(member, "Member");

        vm.prank(owner);
        accessControl.assignOtherRole(member, "Member");

        assertTrue(accessControl.members(member));
    }

    function test_RevertInvalidRole() public {
        vm.prank(owner);
        vm.expectRevert(bytes("Invalid role. Please try again!"));
        accessControl.assignOtherRole(member, "Invalid role");
    }

    function test_RevertNotOwner() public {
        vm.prank(supporter);

        vm.expectRevert(bytes("You are not an admin and cannot call this function!"));
        accessControl.assignOtherRole(member, "Member");
    }
}
