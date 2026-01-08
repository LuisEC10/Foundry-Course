// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SimpleStorage, SimpleStorage2} from "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage public simpleStorage;
    function createSimpleStorageContract() public {
        simpleStorage = new SimpleStorage(); // solidity know to deploy a contract
    }
}