const TokenSeller = artifacts.require('TokenSeller');
const VestingMock = artifacts.require('./mock/VestingMock');

const {expectEvent, expectRevert, time, BN} = require('@openzeppelin/test-helpers');
const Web3 = require('web3');
const web3 = new Web3();

const {expect} = require('chai');

const wei = web3.utils.toWei;

const {
  advanceBlock,
  advanceTime,
  advanceTimeAndBlock,
  takeSnapshot,
  currentTime,
} = require("./helpers/utilsTest");
const { latestBlock } = require('@openzeppelin/test-helpers/src/time');

const SECONDS_IN_DAY = 86400;

contract('TokenSeller', async ([owner, user1, user2, user3, user4]) => {
  let tokenSeller;
  let vestingToken;

  beforeEach(async () => {
    tokenSeller = await TokenSeller.new();

    vestingToken = await VestingMock.new();
    

    await vestingToken.mintArbitrary(owner, wei('100000000'));

  });

  describe('get prices', () => {

    it('Price:', async () => {
      console.log("PPPPPPP:", await tokenSeller.price());
    });

  });

});
