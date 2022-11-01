// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";
import { ISablierV2Linear } from "@sablier/v2-core/interfaces/ISablierV2Linear.sol";
import { SablierV2Linear } from "@sablier/v2-core/SablierV2Linear.sol";

import { SablierV2UnitTest } from "../SablierV2UnitTest.t.sol";

/// @title SablierV2LinearUnitTest
/// @author Sablier Labs Ltd.
/// @notice Common contract members needed across Sablier V2 test contracts.
/// @dev Strictly for test purposes.
abstract contract SablierV2LinearUnitTest is SablierV2UnitTest {
    /*//////////////////////////////////////////////////////////////////////////
                                       EVENTS
    //////////////////////////////////////////////////////////////////////////*/

    event CreateStream(
        uint256 streamId,
        address indexed funder,
        address indexed sender,
        address indexed recipient,
        uint256 depositAmount,
        IERC20 token,
        uint64 startTime,
        uint64 cliffTime,
        uint64 stopTime,
        bool cancelable
    );

    /*//////////////////////////////////////////////////////////////////////////
                                      CONSTANTS
    //////////////////////////////////////////////////////////////////////////*/

    uint64 internal constant TIME_OFFSET = 2_600 seconds;
    uint256 internal immutable WITHDRAW_AMOUNT_DAI = bn(2_600, 18);
    uint256 internal immutable WITHDRAW_AMOUNT_USDC = bn(2_600, 6);

    /*//////////////////////////////////////////////////////////////////////////
                                  TESTING VARIABLES
    //////////////////////////////////////////////////////////////////////////*/

    SablierV2Linear internal sablierV2Linear = new SablierV2Linear();
    ISablierV2Linear.Stream internal daiStream;
    ISablierV2Linear.Stream internal usdcStream;

    /*//////////////////////////////////////////////////////////////////////////
                                   SETUP FUNCTION
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev A setup function invoked before each test case.
    function setUp() public virtual {
        // Create the default streams to be used across the tests.
        daiStream = ISablierV2Linear.Stream({
            cancelable: true,
            cliffTime: CLIFF_TIME,
            depositAmount: DEPOSIT_AMOUNT_DAI,
            sender: users.sender,
            startTime: START_TIME,
            stopTime: STOP_TIME,
            token: dai,
            withdrawnAmount: 0
        });
        usdcStream = ISablierV2Linear.Stream({
            cancelable: true,
            cliffTime: CLIFF_TIME,
            depositAmount: DEPOSIT_AMOUNT_USDC,
            sender: users.sender,
            startTime: START_TIME,
            stopTime: STOP_TIME,
            token: usdc,
            withdrawnAmount: 0
        });

        // Approve the SablierV2Linear contract to spend tokens from the sender.
        vm.startPrank(users.sender);
        dai.approve(address(sablierV2Linear), UINT256_MAX);
        usdc.approve(address(sablierV2Linear), UINT256_MAX);
        nonCompliantToken.approve(address(sablierV2Linear), UINT256_MAX);

        // Approve the SablierV2Linear contract to spend tokens from the recipient.
        changePrank(users.recipient);
        dai.approve(address(sablierV2Linear), UINT256_MAX);
        usdc.approve(address(sablierV2Linear), UINT256_MAX);
        nonCompliantToken.approve(address(sablierV2Linear), UINT256_MAX);

        // Approve the SablierV2Linear contract to spend tokens from Alice.
        changePrank(users.alice);
        dai.approve(address(sablierV2Linear), UINT256_MAX);
        usdc.approve(address(sablierV2Linear), UINT256_MAX);
        nonCompliantToken.approve(address(sablierV2Linear), UINT256_MAX);

        // Approve the SablierV2Linear contract to spend tokens from Eve.
        changePrank(users.eve);
        dai.approve(address(sablierV2Linear), UINT256_MAX);
        usdc.approve(address(sablierV2Linear), UINT256_MAX);
        nonCompliantToken.approve(address(sablierV2Linear), UINT256_MAX);

        // Sets all subsequent calls' `msg.sender` to be `sender`.
        changePrank(users.sender);
    }

    /*//////////////////////////////////////////////////////////////////////////
                               NON-CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Helper function to compare two `Stream` structs.
    function assertEq(ISablierV2Linear.Stream memory a, ISablierV2Linear.Stream memory b) internal {
        assertEq(a.cancelable, b.cancelable);
        assertEq(a.depositAmount, b.depositAmount);
        assertEq(a.sender, b.sender);
        assertEq(a.startTime, b.startTime);
        assertEq(uint256(a.cliffTime), uint256(b.cliffTime));
        assertEq(uint256(a.stopTime), uint256(b.stopTime));
        assertEq(a.token, b.token);
        assertEq(a.withdrawnAmount, b.withdrawnAmount);
    }

    /// @dev Helper function to create a default stream with $DAI used as streaming currency.
    function createDefaultDaiStream() internal returns (uint256 daiStreamId) {
        daiStreamId = sablierV2Linear.create(
            daiStream.sender,
            users.recipient,
            daiStream.depositAmount,
            daiStream.token,
            daiStream.startTime,
            daiStream.cliffTime,
            daiStream.stopTime,
            daiStream.cancelable
        );
    }

    /// @dev Helper function to create a default stream with $USDC used as streaming currency.
    function createDefaultUsdcStream() internal returns (uint256 usdcStreamId) {
        usdcStreamId = sablierV2Linear.create(
            usdcStream.sender,
            users.recipient,
            usdcStream.depositAmount,
            usdcStream.token,
            usdcStream.startTime,
            usdcStream.cliffTime,
            usdcStream.stopTime,
            usdcStream.cancelable
        );
    }

    /// @dev Helper function to create a non-cancelable stream with $DAI used as streaming currency.
    function createNonCancelableDaiStream() internal returns (uint256 nonCancelableDaiStreamId) {
        bool cancelable = false;
        nonCancelableDaiStreamId = sablierV2Linear.create(
            daiStream.sender,
            users.recipient,
            daiStream.depositAmount,
            daiStream.token,
            daiStream.startTime,
            daiStream.cliffTime,
            daiStream.stopTime,
            cancelable
        );
    }
}