/*
    Copyright 2020 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

    SPDX-License-Identifier: Apache License, Version 2.0
*/

pragma solidity 0.6.10;

import { BaseGlobalExtension } from "../lib/BaseGlobalExtension.sol";
import { IDelegatedManager } from "../interfaces/IDelegatedManager.sol";
import { ISetToken } from "../interfaces/ISetToken.sol";

contract BaseGlobalExtensionMock is BaseGlobalExtension {

    mapping(ISetToken=>IDelegatedManager) public initializeInfo;

    /* ============ External Functions ============ */

    function initializeExtension(
        ISetToken _setToken,
        IDelegatedManager _manager
    )
        external
    {
        require(msg.sender == _manager.owner(), "Must be owner");
        initializeInfo[_setToken] = _manager;

        _manager.initializeExtension();
    }

    function testInvokeManager(ISetToken _setToken, address _module, bytes calldata _encoded) external {
        invokeManager(_setToken, _module, _encoded);
    }

    function testOnlyOwner(ISetToken _setToken)
        external
        onlyOwner(_setToken)
    {}

    function testOnlyMethodologist(ISetToken _setToken)
        external
        onlyMethodologist(_setToken)
    {}

    function testOnlyOperator(ISetToken _setToken)
        external
        onlyOperator(_setToken)
    {}

    function removeExtension(ISetToken _setToken) external override onlyManager(_setToken) {
        require(address(_manager(_setToken)) == msg.sender, "Manager must be sender");
        delete initializeInfo[_setToken];
    }

    /* ============ Internal Functions ============ */

    function _manager(ISetToken _setToken) internal override view returns (IDelegatedManager) {
        return initializeInfo[_setToken];
    }
}