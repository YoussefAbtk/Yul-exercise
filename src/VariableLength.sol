// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract VariableLength {
    struct Example {
        uint256 a;
        uint256 b;
        uint256 c;
    }

    function threeArgs(uint256 a, uint256[] calldata b, uint256 c) external {}
    function threeArgsStruct(uint256 a, uint256[] calldata b) external {}
}
