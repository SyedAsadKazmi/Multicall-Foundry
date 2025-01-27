// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Multicall3} from "../src/Multicall3.sol";

import {ContractA} from "../src/ContractA.sol";
import {ContractB} from "../src/ContractB.sol";
import {ContractC} from "../src/ContractC.sol";

contract MulticallTest is Test {
    Multicall3 public multicall;
    ContractA public contractA;
    ContractB public contractB;
    ContractC public contractC;

    function setUp() public {
        multicall = new Multicall3();
        contractA = new ContractA();
        contractB = new ContractB();
        contractC = new ContractC();
    }

    function handleCallFailure(bytes calldata data) external pure returns (string memory) {
        if (data.length >= 4) {
            bytes4 selector = bytes4(data[0:4]);
            if (selector == ContractA.ContractA__Param1CannotBeZero.selector) {
                // You can simply return the error name if you don't need to know the arguments that were passed.
                return "ContractA__Param1CannotBeZero";

                // Otherwise, you can decode the arguments too.
                // (uint256 arg1, string memory arg2) = abi.decode(data[4:], (uint256, string));
                // return string(abi.encodePacked("Custom Error: arg1=", arg1.toString(), ", arg2=", arg2));
            } else if (selector == ContractB.ContractB__Param2CannotBeEmptyString.selector) {
                return "ContractB__Param2CannotBeEmptyString";
            } else if (selector == ContractC.ContractC__Param3CannotBeZeroAddress.selector) {
                return "ContractC__Param3CannotBeZeroAddress";
            } else {
                return abi.decode(data[4:], (string));
            }
        }
        return "Unknown Error"; // If some incorrect function signature is used in the low level address.call or so, then "Unknown Error" would be returned
    }

    function test_MulticallAggregate() public {
        Multicall3.Call[] memory batchCalls = new Multicall3.Call[](9);
        Multicall3.Result[] memory result = new Multicall3.Result[](9);
        address target_A = address(contractA);
        address target_B = address(contractB);
        address target_C = address(contractC);

        batchCalls[0] = Multicall3.Call({
            target: target_A,
            callData: abi.encodeWithSignature("testCallA(uint256,string,address)", 1, "abc", address(1))
        }); // No Error

        batchCalls[1] = Multicall3.Call({
            target: target_A,
            callData: abi.encodeWithSignature("testCallA(uint256,string,address)", 0, "abc", address(1))
        }); // Custom Error

        batchCalls[2] = Multicall3.Call({
            target: target_A,
            callData: abi.encodeWithSignature("testCallA_WithRevertString(uint256,string,address)", 0, "abc", address(1))
        }); // Revert String

        batchCalls[3] = Multicall3.Call({
            target: target_B,
            callData: abi.encodeWithSignature("testCallB(uint256,string,address)", 1, "abc", address(1))
        }); // No Error

        batchCalls[4] = Multicall3.Call({
            target: target_B,
            callData: abi.encodeWithSignature("testCallB(uint256,string,address)", 1, "", address(1))
        }); // Revert String

        batchCalls[5] = Multicall3.Call({
            target: target_B,
            callData: abi.encodeWithSignature("testCallB_WithRevertString(uint256,string,address)", 1, "", address(1))
        }); // Revert String

        batchCalls[6] = Multicall3.Call({
            target: target_C,
            callData: abi.encodeWithSignature("testCallC(uint256,string,address)", 1, "abc", address(1))
        }); // No Error

        batchCalls[7] = Multicall3.Call({
            target: target_C,
            callData: abi.encodeWithSignature("testCallC(uint256,string,address)", 1, "abc", address(0))
        }); // Custom Error

        batchCalls[8] = Multicall3.Call({
            target: target_C,
            callData: abi.encodeWithSignature("testCallC_WithRevertString(uint256,string,address)", 1, "abc", address(0))
        }); // Revert String

        result = multicall.tryAggregate(false, batchCalls);

        string[] memory errors = new string[](9);

        for (uint256 i = 0; i < result.length; i++) {
            if (result[i].success) {
                errors[i] = "No Error";
            } else {
                // console.logBytes(result[0].returnData);
                errors[i] = this.handleCallFailure(result[i].returnData);
            }
        }

        for (uint256 i = 0; i < errors.length; i++) {
            console.log("Error in Batch Call", i + 1, ":", errors[i]);
        }
    }
}
