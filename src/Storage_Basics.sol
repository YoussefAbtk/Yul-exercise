// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract StorageBasics {
    uint256 x = 2;
    uint256 y = 13;
    uint256 z = 54;
    uint256 p;
    uint128 a;
    uint128 b;

    function getSlot() external pure returns (uint256 slot) {
        assembly {
            slot := a.slot
        }
    }

    function getX(uint256 slot) external view returns (uint256 ret) {
        assembly {
            ret := sload(x.slot)
        }
    }

    function setX(uint256 newVal) external {
        x = newVal;
    }

    function setVarYul(uint256 slot, uint256 newVal) external {
        assembly {
            sstore(slot, newVal)
        }
    }
}
