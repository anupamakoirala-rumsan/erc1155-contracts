// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.10;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/utils/math/Math.sol';

contract Reward is ERC1155{
    using Counters for Counters.Counter;
    using Math for uint256;

    Counters.Counter private _currentTokenId;
    // uint256 private _currenTokenId = 0;

    string public name;
    string public symbol;

    mapping(uint256=>uint256) public tokenSupply;

    mapping(uint256 => address) public creators;

    constructor(string memory _name, string memory _symbol) ERC1155(''){
        name = _name;
        symbol = _symbol;
    }

    function createToken(uint256 _initialSupply, string memory uri) public returns(uint256){
        uint256 _id = _currentTokenId.current();
        creators[_id] = msg.sender;
        _mint(msg.sender, _id, _initialSupply,'');
        tokenSupply[_id] = _initialSupply;
        return _id;
    }

    function mintToken(address _to ,uint256 _id, uint256 _quantity) public{
        _mint(_to, _id, _quantity, '');
        tokenSupply[_id] = tokenSupply[_id]+_quantity;
    }
}

