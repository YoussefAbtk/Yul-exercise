// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {ExternalCalls, OtherContract} from "../src/ExternalCalls.sol";

contract ExternalCallsTest is Test {
    ExternalCalls caller;
    OtherContract called;
    uint256[] args1 = [1, 2, 3, 4, 5];
    uint256[] args2 = [1, 2, 3, 4, 5];

    function setUp() external {
        called = new OtherContract();
        caller = new ExternalCalls();
    }

    function testCallsWithNoArgs() external {
        uint256 c = caller.externalViewCallNoArgs(address(called));

        assertEq(c, 21);
    }

    function testGetViaReverts() external {
        uint256 c = caller.getViaRevert(address(called));
        assertEq(c, 999);
    }

    function testMultiplyCall() external {
        uint256 c = caller.callMultiply(address(called));
        assertEq(c, 33);
    }

    function testExternalCall() external {
        caller.externalStateChangingCall(address(called));
        uint256 x;
        address c = address(called);
        assembly {
            mstore(0x00, 0x0c55699c)
            let success := staticcall(gas(), c, 0x1c, 0x20, 0x00, 0x20)
            if iszero(success) { revert(0, 0) }
            x := mload(0x00)
        }

        assertEq(x, 999);
    }

    function testUnknownReturnSize() external {
        address oC = address(called);
        bytes memory c;
        assembly {
            mstore(0x00, 0x52bd0fa3)
            mstore(0x20, 3)
            let success := staticcall(gas(), oC, 0x1c, 0x20, 0x00, 0x00)
            if iszero(success) { revert(0, 0) }
            returndatacopy(0, 0, returndatasize())
            c := mload(0x00)
        }

        console.logBytes(c);
    }

    function testdealWithDynamiccalldata2() external {

        bool isTrue = caller.dealWithDynamiccalldata(address(called));
         
      assertEq(isTrue, true);

    }
    function testdealWithDynamicCalldata() external {
        bool isTrue = caller.dealWithDynamiccalldata3(args1, args2,address(called)); 
        assertEq(isTrue, true);
    }
    function testdealWithDynamicCalldata3() external {
        bool isTrue = caller.dealWithDynamiccalldata4(args1, args2);
        assertEq(isTrue, true);
    }

    function testmultipleLength() external {}
}
