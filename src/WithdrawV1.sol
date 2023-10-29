// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract WithdrawV1 {
    constructor() payable {}

    address public constant owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    function withdraw1() external {
        (bool s,) = payable(owner).call{value: address(this).balance}("");
        require(s);
    }

    function withdraw2() external {
        assembly {
            let s := call(gas(), owner, selfbalance(), 0, 0, 0, 0)
            if iszero(s) { revert(0, 0) }
        }
    }
}
