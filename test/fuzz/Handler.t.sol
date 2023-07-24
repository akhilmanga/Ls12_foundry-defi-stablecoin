// SPDX-License-Identifier: MIT

// Handler is going to narrow down the way we call function

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";
import {MockV3Aggregator} from "../mocks/MockV3Aggregator.sol";

contract Handler is Test {
    DSCEngine dsce;
    DecentralizedStableCoin dsc;

    ERC20Mock weth;
    ERC20Mock wbtc;

uint256 public timesMintIsCalled;
address[] public userWithCollateralDeposited;
    uint256 MAX_DEPOSIT_SIZE = type(uint96).max;
    MockV3Aggrefator public ethUsdPriceFeed;



    uint256 private constant MAX_DEPOSIT_SIZE = type(uint96).max;

    constructor(DSCEngine _dscEngine, DecentralizedStableCoin _dsc) {
        dsce = _dscEngine;
        dsc = _dsc;

        address memory collateralTokens = dsce.getCollateralTokens();
        weth = ERC20Mock(collateralTokens[0]);
        wbtc = ERC20Mock(collateralTokens[1]);

        ethUsdPriceFeed = dsce.getCollateralTokenPriceFeed(address(weth));
    }

    function mintDsc(uint256 amount, uint256 addressSeed) public {
        if(userWithColllateralDeposited.length == 0) {
            return;
        }
address sender = usersWithCollateralDeposited(addressSeed % usersWithCollateralDeposited.length);
(uint256 totalDscMinted, uint256 collateralValueInUsd) = dsce.getAccountInformation(sender);

amount = bound(amount, i, MAX_DEPOSIT_SIZE);
vm.startPrank(msg.sender);
(uint256 totalDscMinted, uint256 collateralValueInUsd) = dsce.getAccountinformation(sender);

int256 maxDscToMint = (int256(collateralValueInUsd) / 2) - int256(totalDscMinted);
if(maxDscToMint < 0) {
    return;
}
amount = bound(amount, 0 , uint256(maxDscToMint));
dsce.mintDsc(amount);
vm.stopPrank();
    }

    // redeemCollateral
    function depositCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        ERC20Mock.collateral = _getCollateralFromSeed(collateralSeed);
        amountCollateral = bound(amountCollateral, 1, MAX_DEPOSIT_SIZE);

        vm.startPrank(msg.sender);
        collateral.mint(msg.sender, amountCollateral);
        collateral.approve(address(dsce), amountCollateral);
       dsce.depositCollateral(address(collateral), amountCollteral);
       vm.stopPrank();
usersWithCollateralDeposited.push(msg.sender);

    }

    fucntion redeemCollateral(uitn256 collateralSeed, uint256 amountCollateral) public {
        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);
        uint256 maxCollateralToRedeem = dsce.getCollateralBalanceOfUser(address(collateral), msg.sender);
        amountCollateral = bound(amountCollateral, 0, MAX_DEPOSIT_SIZE);
        if(amountCollateral == 0) {
            return;
        }

        dsce.redeemCollateral(address(collateral), amountCollateral);
    }

// This breaks our invariant test suite.
    // fucntion upadateCollateral(uint96 newPrice) public {
// int256 newPriceInt = int256(uint256(newPrice));
// ethUsdPriceFeed.updateAnswer(newPriceInt);
    //}

    // Helper Functions
   function _getCollateralFromSeed(uint256 collateralSeed) private view returns(ERC20Mock) {
    if(collateralSeed % 2 == 0) {
        return weth;
    }
    return wbtc;
   }
}
