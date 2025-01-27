// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ContractC {
    error ContractC__Param3CannotBeZeroAddress();

    uint256 public s_param1;
    string public s_param2;
    address public s_param3;

    function callC(uint256 param1, string memory param2, address param3) public returns (bool) {
        if (param3 == address(0)) {
            revert ContractC__Param3CannotBeZeroAddress();
        }
        s_param1 = param1;
        s_param2 = param2;
        s_param3 = param3;
        return true;
    }

    function callC_WithRevertString(uint256 param1, string memory param2, address param3) public returns (bool) {
        if (param3 == address(0)) {
            revert("ContractC__Param3CannotBeZeroAddress");
        }
        s_param1 = param1;
        s_param2 = param2;
        s_param3 = param3;
        return true;
    }
}
