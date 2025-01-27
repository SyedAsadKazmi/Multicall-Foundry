// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ContractB {
    error ContractB__Param2CannotBeEmptyString();

    uint256 public s_param1;
    string public s_param2;
    address public s_param3;

    function testCallB(uint256 param1, string memory param2, address param3) public returns (bool) {
        if (bytes(param2).length == 0) {
            revert ContractB__Param2CannotBeEmptyString();
        }
        s_param1 = param1;
        s_param2 = param2;
        s_param3 = param3;
        return true;
    }

    function testCallB_WithRevertString(uint256 param1, string memory param2, address param3) public returns (bool) {
        if (bytes(param2).length == 0) {
            revert("ContractB__Param2CannotBeEmptyString");
        }
        s_param1 = param1;
        s_param2 = param2;
        s_param3 = param3;
        return true;
    }
}
