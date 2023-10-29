// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {StorageBasics2} from "../src/Storage_Basics2.sol";

contract StorgaeBasicsTest is Test {
    StorageBasics2 storageB;

    function setUp() public {
        storageB = new StorageBasics2();
    }

    function testReadE() external {
        uint16 e = storageB.readE();
        assertEq(e, 8);
    }

    function testReadEalt() external {
        (uint256 e, bytes32 shifted) = storageB.readEalt();
        console.logBytes32(shifted);
        assertEq(e, 8);
    }

    function testWriteToE() external {
        storageB.writeToE(5);
        uint16 e = storageB.readE();
        assertEq(e, 5);
    }
}
