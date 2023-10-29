// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract CallDemo {
    fallback(bytes calldata data) external returns (bytes memory returnData) {
        assembly {
            let cd := calldataload(0)
            let selector := shr(0xe0, cd)

            switch selector
            case 0xd2178b08 { returnUint(2) }
            case 0xba88df04 { returnUint(getNotSoSecretValue()) }
            default { revert(0, 0) }
            function returnUint(v) {
                mstore(0, v)
                return(0, 0x20)
            }
            function getNotSoSecretValue() -> r {
                if lt(calldatasize(), 36) { revert(0, 0) }
                let arg1 := calldataload(4)
                if eq(arg1, 8) {
                    r := 88
                    leave
                }
                r := 99
            }
        }
    }
  
}
