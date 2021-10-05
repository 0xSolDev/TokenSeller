// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
contract TokenSeller is OwnableUpgradeable{


	address sellToken;
	address tokenOwner;
	address[] buyTokens;
	uint256 price;
	address[] proxies;
	AggregatorV3Interface[] internal priceFeed;

	/**/// @title A title that should describe the contract/interface
	/// @author The name of the author
	/// @notice Explain to an end user what this does
	/// @dev Explain to a developer any extra details */
	function initialize(address _sellToken, address[] memory _buyTokens, address _tokenOwner)
		external
		initializer
	{
		require(_buyTokens.length > 0, 'initialize : length must be greater than 0');
		__Ownable_init();
		sellToken = _sellToken;
		buyTokens = _buyTokens;
		tokenOwner = _tokenOwner;
	}
	/**
		* @param _price the price of the sellToken
	 */
	function setPrice(uint256 _price) external {
		require(tokenOwner == address(msg.sender), 'setPrice : not an owner');
		require(_price > 0, 'setPrice : price must be greater than 0');
		price = _price;
	}
	/**
		* @param _price arrary of the address that are listed on ChainLink Ethereum Data Feeds
		https://docs.chain.link/docs/ethereum-addresses/

		@requirements
			- only token owner can call
			- buyToken length should same with of length _proxies
	 */
	function setProxyInfoForChainLink(address[] memory _proxies) external {
		require(tokenOwner == address(msg.sender), 'setProxyInfoForChainLink : not an owner');
		require(_proxies.length == buyTokens.length, 'setProxyInfoForChainLink : length doesnt match');

		for (uint256 i = 0; i < _proxies.length; i++) {
			priceFeed.push(AggregatorV3Interface(_proxies[i]));
		}
		proxies = _proxies;
	}
	/**
		* @param _to address that will transfer tokens unpon destrying contracts
	 */
	function destroyContract(address payable _to) external {
		require(tokenOwner == address(msg.sender), 'destroyContract : not an owner');

		for (uint256 i = 0; i < buyTokens.length; i++) {
			if(IERC20Upgradeable(buyTokens[i]).balanceOf(address(this)) > 0){
				IERC20Upgradeable(buyTokens[i]).transfer(_to,IERC20Upgradeable(buyTokens[i]).balanceOf(address(this)));
			}
		}
		IERC20Upgradeable(sellToken).transfer(_to,IERC20Upgradeable(sellToken).balanceOf(address(this)));
		selfdestruct(_to);
	}
	/**
		* requirements : returns the prices of the token that added by calling setProxyInfoForChainLink()
	 */
	function getPriceFromChainLink() public view returns (uint256[] memory) {
		uint256[] memory prices = new uint256[](proxies.length);
		for (uint256 i = 0; i < proxies.length; i++) {
			(,int tokenPrice,,,) = priceFeed[i].latestRoundData();
			prices[i] = uint256(tokenPrice);
		}
		return prices;
	}
}