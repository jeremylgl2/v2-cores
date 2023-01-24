// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import { ISablierV2 } from "src/interfaces/ISablierV2.sol";

import { LinearTest } from "test/unit/sablier-v2/linear/LinearTest.t.sol";
import { WithdrawMax_Test } from "test/unit/sablier-v2/shared/withdraw-max/withdrawMax.t.sol";

contract WithdrawMax_LinearTest is LinearTest, WithdrawMax_Test {
    function setUp() public virtual override(LinearTest, WithdrawMax_Test) {
        WithdrawMax_Test.setUp();
        sablierV2 = ISablierV2(linear);
    }
}