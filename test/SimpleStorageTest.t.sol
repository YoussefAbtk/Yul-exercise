// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {Array} from "../src/SimpleStorage2.sol";

contract SimpleStorageTest is Test {
    Array array;

    function setUp() public {
        array = new Array();
    }

    function testslot() external {
        uint256 slot = array.getArrayDSlot(0);
        assertEq(slot, 100);
    }

    function testLength() external {
        uint256 l = array.getArrayDlength();
        assertEq(l, 3);
    }

    function testArrayFixed() external {
        uint256 value = array.getFixedArray(0);

        assertEq(value, 1);
    }
}
