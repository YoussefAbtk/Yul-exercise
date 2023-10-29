// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {StorageComplex} from "../src/Storage_Complex.sol";

contract ComplexStorageTest is Test {
    StorageComplex storageComplex;

    function setUp() external {
        storageComplex = new StorageComplex();
    }

    function testGetArray() external {
        uint256 value = storageComplex.getFixedArray(0);

        assertEq(value, 99);
    }

    function testgetBigArray() external {
        uint256 value = storageComplex.bigArrayView(0);
        assertEq(10, value);
    }

    function testGetMapping() external {
        uint256 value = storageComplex.getMapping(10);
        assertEq(5, value);
    }

    function testGetNestedMapping() external {
        uint256 value = storageComplex.getNestedMapping(4, 2);

        assertEq(value, 7);
    }

    function testOfLengthNested() external {
        uint256 value = storageComplex.lengthOfNestedList();
        assertEq(value, 3);
    }

    function testGetAddressToList() external {
        uint256 value = storageComplex.getAddressToList(0);
        assertEq(value, 42);
    }
}
