// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";

import { CreateWithMilestones_Test } from "../create/createWithMilestones.t.sol";
import { CreateWithRange_Test } from "../create/createWithRange.t.sol";

/// @dev A typical 18-decimal token with a normal total supply.
IERC20 constant token = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
address constant holder = 0x66F62574ab04989737228D18C3624f7FC1edAe14;

contract DAI_CreateWithMilestones_Test is CreateWithMilestones_Test(token, holder) {}

contract DAI_CreateWithRange_Test is CreateWithRange_Test(token, holder) {}
