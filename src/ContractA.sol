// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ContractA {
    error ContractA__Param1CannotBeZero();

    uint256 public s_param1;
    string public s_param2;
    address public s_param3;

    function callA(uint256 param1, string memory param2, address param3) public returns (bool) {
        if (param1 == 0) {
            revert ContractA__Param1CannotBeZero();
        }
        s_param1 = param1;
        s_param2 = param2;
        s_param3 = param3;
        return true;
    }

    function callA_WithRevertString(uint256 param1, string memory param2, address param3) public returns (bool) {
        if (param1 == 0) {
            revert("ContractA__Param1CannotBeZero");
        }
        s_param1 = param1;
        s_param2 = param2;
        s_param3 = param3;
        return true;
    }
}
