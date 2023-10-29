// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {StorageComplex} from "../src/Storage_Complex.sol";

contract StorageComplexTest is Test {
    StorageComplex storageComplex;

    function setUp() public {
        storageComplex = new StorageComplex();
    }

    function testGetMapping() external {
        uint256 number = storageComplex.getMapping(10);

        assertEq(number, 5);
    }
}
