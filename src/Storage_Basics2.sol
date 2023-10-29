// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract StorageBasics2 {
    uint128 public c = 4;
    uint96 public d = 6;
    uint16 public e = 8;
    uint8 public f = 1;

    function readBySlot(uint256 slot) external view returns (uint256 value) {
        assembly {
            value := sload(slot)
        }
    }

    function getOffsetE() external pure returns (uint256 slot, uint256 offset) {
        assembly {
            slot := e.slot
            offset := e.offset
        }
    }

    function readE() external view returns (uint16 E) {
        assembly {
            let value := sload(e.slot)
            let shifted := shr(mul(e.offset, 8), value)
            E := and(0xffffffff, shifted)
        }
    }

    function readEalt() external view returns (uint256 E, bytes32 shifted) {
        assembly {
            let value := sload(e.slot)

            shifted := div(value, 0x100000000000000000000000000000000000000000000000000000000)
            E := and(0xffff, shifted)
        }
    }

    function writeBySlot(uint256 slot, uint256 value) external {
        assembly {
            sstore(slot, value)
        }
    }

    function writeToE(uint16 newE) external {
        assembly {
            let C := sload(e.slot)

            let clearedE := and(C, 0xffff0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff)

            let shiftedNewE := shl(mul(e.offset, 8), newE)

            let newVal := or(shiftedNewE, clearedE)

            sstore(c.slot, newVal)
        }
    }
}
