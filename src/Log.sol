// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Log {
    event SomeLog(uint256 indexed a, uint256 indexed b);
    event SomeLogV2(uint256 indexed a, bool);

    function emitLog() external {
        emit SomeLog(5, 6);
    }

    function yulEmitLog() external {
        assembly {
            let signature := 0xc200138117cf199dd335a2c6079a6e1be01e6592b6a76d4b5fc31b169df819cc
            log3(0, 0, signature, 5, 6)
        }
    }

    function v2EmitLog() external {
        emit SomeLogV2(5, true);
    }

    function v2YulEmitLog() external {
        assembly {
            let signature := 0xc200138117cf199dd335a2c6079a6e1be01e6592b6a76d4b5fc31b169df819cc
            mstore(0x00, 1)
            log2(0, 0x20, signature, 5)
        }
    }
}
