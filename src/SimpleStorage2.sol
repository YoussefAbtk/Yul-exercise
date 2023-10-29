// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Array {
    uint256[] ArrayD;
    uint256[3] ArrayF;
    uint8[] Arrays;

    constructor() {
        ArrayD = [100, 20, 30];
        ArrayF = [1, 2, 3];
        Arrays = [1, 2, 3];
    }

    function getArrayDSlot(uint256 _index) external view returns (uint256 ret) {
        assembly {
            let slot := ArrayD.slot
            mstore(0x00, slot)
            let location := keccak256(0x00, 0x20)

            ret := sload(add(location, _index))
        }
    }

    function getArrayDlength() external view returns (uint256 l) {
        assembly {
            let slot := ArrayD.slot
            l := sload(slot)
        }
    }

    function getFixedArray(uint256 _index) external view returns (uint256 value) {
        assembly {
            let slot := ArrayF.slot
            value := sload(add(slot, _index))
        }
    }
}
