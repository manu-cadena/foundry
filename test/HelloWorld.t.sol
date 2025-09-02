// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {HelloWorld} from "../src/HelloWorld.sol";

contract HelloWorldTest is Test {
    HelloWorld helloWorld;
    string constant INITIAL = "Hello world"; // Match the default value in contract

    // Körs inför varje test, precis om beforeEach i JavaScript.
    function setUp() public {
        helloWorld = new HelloWorld();
    }

    /*----------Deployment----------*/

    function test_Deployment_SetInitialMessage() public view {
        assertEq(helloWorld.message(), INITIAL);
    }

    /*----------Message update----------*/
    function test_UpdateMessage() public {
        string memory newMessage = "BCU24D";
        assertEq(helloWorld.message(), INITIAL);

        helloWorld.setMessage(newMessage);

        assertEq(helloWorld.message(), newMessage);
    }

    function test_AllowMultipleUpdates() public {
        string memory firstMessage = "First message";
        string memory secondMessage = "Second message";

        // Initial state
        assertEq(helloWorld.message(), INITIAL);

        // First update
        helloWorld.setMessage(firstMessage);
        assertEq(helloWorld.message(), firstMessage);

        // Second update
        helloWorld.setMessage(secondMessage);
        assertEq(helloWorld.message(), secondMessage);
    }

    /*----------Retrieve message----------*/

    function test_GetMessage() public {
        assertEq(helloWorld.message(), INITIAL);

        string memory newMessage = "BCU24D";
        helloWorld.setMessage(newMessage);

        assertEq(helloWorld.getMessage(), newMessage);
    }
}
