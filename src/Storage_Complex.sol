// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract StorageComplex {
    uint256[3] fixedArray;
    uint256[] bigArray;
    uint8[] smallArray; 
    mapping(uint256 => uint256) public myMapping;
    mapping(uint256 => mapping(uint256 => uint256)) public nestedMapping;
    mapping(address => uint256[]) public addressToList;

    constructor() {
        fixedArray = [99, 999, 999];
        bigArray = [10, 20, 30];
        smallArray = [1, 2, 3];

        myMapping[10] = 5;
        myMapping[11] = 6;
        nestedMapping[2][4] = 7;
        addressToList[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = [42, 1337, 777];
    }

    function getFixedArray(uint256 _index) external view returns (uint256 value) {
        assembly {
            let slot := fixedArray.slot
            value := sload(add(slot, _index))
        }
    }

    function fixedArrayView(uint256 index) external view returns (uint256 ret) {
        assembly {
            ret := sload(index)
        }
    }

    function bigArrayView(uint256 _index) external view returns (uint256 ret) {
        assembly {
            mstore(0x00, bigArray.slot)
            let valueSlot := keccak256(0x00, 0x20)
            ret := sload(add(valueSlot, _index))
        }
    }

    function getMapping(uint256 key) external view returns (uint256 ret) {
        uint256 slot;
        assembly {
            slot := myMapping.slot
        }
        bytes32 location = keccak256(abi.encode(key, uint256(slot)));
        assembly {
            ret := sload(location)
        }
    }

    function getNestedMapping(uint256 key1, uint256 key2) external view returns (uint256 ret) {
        uint256 slot;
        assembly {
            slot := nestedMapping.slot
        }
        bytes32 location = keccak256(abi.encode(key1, keccak256(abi.encode(key2, uint256(slot)))));
        assembly {
            ret := sload(location)
        }
    }

    function lengthOfNestedList() external view returns (uint256 ret) {
        uint256 addressToListSlot;
        assembly {
            addressToListSlot := addressToList.slot
        }
        bytes32 location =
            keccak256(abi.encode(address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), uint256(addressToListSlot)));
        assembly {
            ret := sload(location)
        }
    }

    function getAddressToList(uint256 index) external view returns (uint256 ret) {
        uint256 slot;
        assembly {
            slot := addressToList.slot
        }
        bytes32 location = keccak256(
            abi.encode(keccak256(abi.encode(address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), uint256(slot))))
        );
        assembly {
            ret := sload(add(index, location))
        }
    }
}
