// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract OtherContract {
    // "0c55699c": "x()"
    uint256 public x;

    // "71e5ee5f": "arr(uint256)",
    uint256[] public arr;

    // "9a884bde": "get21()",
    function get21() external pure returns (uint256) {
        return 21;
    }

    // "73712595": "revertWith999()",
    function revertWith999() external pure returns (uint256) {
        assembly {
            mstore(0x00, 999)
            revert(0x00, 0x20)
        }
    }

    // "4018d9aa": "setX(uint256)"
    function setX(uint256 _x) external {
        x = _x;
    }

    // "196e6d84": "multiply(uint128,uint16)",
    function multiply(uint128 _x, uint16 _y) external pure returns (uint256) {
        return _x * _y;
    }

    // "0b8fdbff": "variableLength(uint256[])",
    function variableLength(uint256[] calldata data) external {
        arr = data;
    }

    // "7c70b4db": "variableReturnLength(uint256)",
    function variableReturnLength(uint256 len) external pure returns (bytes memory) {
        bytes memory ret = new bytes(len);
        for (uint256 i = 0; i < ret.length; i++) {
            ret[i] = 0xab;
        }
        return ret;
    }

    // exercise for the reader #1
    function multipleVariableLength(uint256[] calldata data1, uint256[] calldata data2) external pure returns (bool) {
        require(data1.length == data2.length, "invalid");

        // this is often better done with a hash function, but we want to enforce
        // the array is proper for this test
        for (uint256 i = 0; i < data1.length; i++) {
            if (data1[i] != data2[i]) {
                return false;
            }
        }
        return true;
    }

    // exercise for the reader #2
    function multipleVariableLength2(uint256 max, uint256[] calldata data1, uint256[] calldata data2)
        external
        pure
        returns (bool)
    {
        require(data1.length < max, "data1 too long");
        require(data2.length < max, "data2 too long");

        for (uint256 i = 0; i < max; i++) {
            if (data1[i] != data2[i]) {
                return false;
            }
        }
        return true;
    }
}

contract ExternalCalls {
    function externalViewCallNoArgs(address _a) external view returns (uint256) {
        assembly {
            mstore(0x00, 0x9a884bde)
            let success := staticcall(gas(), _a, 28, 32, 0x00, 0x20)
            if iszero(success) { revert(0, 0) }
            return(0x00, 0x20)
        }
    }

    function getViaRevert(address _a) external view returns (uint256) {
        assembly {
            mstore(0x00, 0x73712595)
            pop(staticcall(gas(), _a, 28, 32, 0x00, 0x20))
            return(0x00, 0x20)
        }
    }

    function callMultiply(address _a) external view returns (uint256 result) {
        assembly {
            let mptr := mload(0x40)
            let oldMptr := mptr
            mstore(mptr, 0x196e6d84)
            mstore(add(mptr, 0x20), 3)
            mstore(add(mptr, 0x40), 11)
            mstore(0x40, add(mptr, 0x60))
            let success := staticcall(gas(), _a, add(oldMptr, 28), mload(0x40), 0x00, 0x20)
            if iszero(success) { revert(0, 0) }
            result := mload(0x00)
            return(0x00, 0x20)
        }
    }

    function externalStateChangingCall(address _a) external {
        assembly {
            mstore(0x00, 0x4018d9aa)
            mstore(0x20, 999)

            let success := call(gas(), _a, callvalue(), 28, add(28, 32), 0x00, 0x00)
            if iszero(success) { revert(0, 0) }
        }
    }

    function unknownReturnSize(address _a, uint256 amount) external view returns (bytes memory) {
        assembly {
            mstore(0x00, 0x7c70b4db)
            mstore(0x20, amount)
            let success := staticcall(gas(), _a, 28, add(28, 32), 0x00, 0x00)
            if iszero(success) { revert(0, 0) }
            returndatacopy(0, 0, returndatasize())
            return(0, returndatasize())
        }
    }

    function dealWithDynamiccalldata(address _a)
        external
        view
        returns (bool isTrue )
    {
        assembly {
            let mptr := mload(0x40)
            mstore(mptr, 0x5fa88e2a)
            mstore(add(mptr, 0x20), 0x40)
            mstore(add(mptr, 0x40), 0x100)
            mstore(add(mptr, 0x60), 0x5)
            mstore(add(mptr, 0x80), 0x1)
            mstore(add(mptr, 0xa0), 0x2)
            mstore(add(mptr, 0xc0), 0x3)
            mstore(add(mptr, 0xe0), 0x4)
            mstore(add(mptr, 0x100), 0x5)
            mstore(add(mptr, 0x120), 0x5)
            mstore(add(mptr, 0x140), 0x1)
            mstore(add(mptr, 0x160), 0x2)
            mstore(add(mptr, 0x180), 0x3)
            mstore(add(mptr, 0x1a0), 0x4)
            mstore(add(mptr, 0x1c0), 0x5)
            mstore(0x40, 0x1e0)
            let success := staticcall(gas(), _a, 0x9c, 0x1c4, 0x00, 0x20 )
            if iszero(success) {revert(0,0)}
            return(0x00, 0x20)
            
        }
        
    }
    function dealWithDynamiccalldata3(uint256[] calldata arr1, uint256[] calldata arr2, address _a) external view returns(bool){
    bytes memory someCalldata = abi.encodeWithSelector(0x5fa88e2a, arr1, arr2);
    assembly {
        let location := someCalldata
        let len := mload(location)
        let success := staticcall(gas(), _a,add(location, 0x20), len, 0x00,0x20 )
        if iszero(success){
            revert(0,0)
        }
        return(0x00,0x20)
    }
    }

    function dealWithDynamiccalldata2(uint256[] calldata arr1, uint256[] calldata arr2, address _a)
        external
        view
        returns (bool, bytes memory)
    {
        bytes memory someCalldata = abi.encodeWithSelector(0x5fa88e2a, arr1, arr2);
        (bool success, bytes memory data) = _a.staticcall(abi.encodeWithSelector(0x5fa88e2a, arr1, arr2));
        if (!success) {
            revert();
        }

        return (abi.decode(data, (bool)), someCalldata);
    }
    function dealWithDynamiccalldata4(uint256[] calldata arr1, uint256[] calldata arr2) external view returns(bool){
        assembly {
            let mptr := mload(0x40)
            mstore(mptr,0x5fa88e2a )
            calldatacopy(add(mptr, 0x20), 0, calldatasize())
            let success := staticcall(gas(), 0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f, add(mptr, 0x1c), add(calldatasize(),0x4),0x00,0x20)
            if iszero(success) {revert(0,0)}
            return(0x00,0x20)


        }

    }
}
