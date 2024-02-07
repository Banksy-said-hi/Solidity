// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Child {
    string public greeting;

    constructor(string memory _greeting) {
        greeting = _greeting;
    }
}

contract Factory {
    event Deployed(address addr, bytes32 salt);

    function deployChild(bytes32 salt, string memory _greeting) public {
        // Define the bytecode of the Child contract
        // For simplicity, we're using hardcoded bytecode.
        // In a real scenario, you should generate the bytecode dynamically or retrieve it in a manner
        // that reflects the actual contract you wish to deploy.
        bytes memory bytecode = type(Child).creationCode;

        // Append constructor arguments to the bytecode
        bytes memory bytecodeWithArgs = abi.encodePacked(bytecode, abi.encode(_greeting));

        address child;

        assembly {
            // Create2 call arguments: endowment, bytecode length, bytecode, salt
            child := create2(0, add(bytecodeWithArgs, 0x20), mload(bytecodeWithArgs), salt)
            
            // Check if the CREATE2 call succeeded by verifying the child address is not zero
            if iszero(child) {
                revert(0, 0)
            }
        }

        // Emit an event with the address of the deployed contract
        emit Deployed(child, salt);
    }
}


