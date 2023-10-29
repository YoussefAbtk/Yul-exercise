// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract IfComparison {
    function isTruthy() external pure returns (uint256 result) {
        result = 2;
        assembly {
            if 2 { result := 1 }
        }
        return result;
    }

    function isFalsy() external pure returns (uint256 result) {
        result = 1;
        assembly {
            if 0 { result := 2 }
        }
        return result;
    }

    function negation() external pure returns (uint256 result) {
        result = 1;
        assembly {
            if iszero(0) { result := 2 }
        }
        return result;
    }

    function unsafeNegationPart1() external pure returns (uint256 result) {
        result = 1;
        assembly {
            if not(0) { result := 2 }
        }
        return result;
    }

    function bitFlip() external pure returns (bytes32 result) {
        assembly {
            result := not(2)
        }
    }

    function unsafeNegationPart2() external pure returns (uint256 result) {
        result = 1;
        assembly {
            if not(2) { result := 2 }
        }
        return result;
    }

    function safeNegation() external pure returns (uint256 result) {
        result = 1;
        assembly {
            if iszero(2) { result := 2 }
        }
        return result;
    }

    function max(uint256 x, uint256 y) external pure returns (uint256 maximum) {
        assembly {
            if lt(x, y) { maximum := y }
            if iszero(lt(x, y)) { maximum := x }
        }
    }
}
