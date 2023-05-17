// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.10;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/utils/math/Math.sol';

contract Reward is ERC1155{
    using Counters for Counters.Counter;
    using Math for uint256;

    Counters.Counter private _currentTokenId;

    string public name;
    string public symbol;

    mapping(uint256=>uint256) public tokenSupply;
    mapping(uint256=>uint256) public tokenReserve;
    mapping(uint256 => address) public creators;
    mapping(address=>bool) public admin;

    constructor(string memory _name, string memory _symbol, string memory _uri) ERC1155(''){
        name = _name;
        symbol = _symbol;
        admin[msg.sender] = true;
        _setURI(_uri);
    }

    modifier onlyAdmin(){
        require(admin[msg.sender],"Not admin");
        _;
    }

    function createToken(uint256 _initialSupply, uint256 _tokenReserve) public onlyAdmin() returns(uint256) {
        uint256 _id = _currentTokenId.current();
        creators[_id] = msg.sender;
        tokenSupply[_id] = _initialSupply;
        tokenReserve[_id] = _tokenReserve;
        _currentTokenId.increment();
        _mint(msg.sender, _id, _initialSupply,'');
        return _id;
    }

    function mintToken(address _to ,uint256 _id, uint256 _quantity) public{
        require(tokenReserve[_id]>tokenSupply[_id] + _quantity,"Token limit hit");
        _mint(_to, _id, _quantity, '');
        tokenSupply[_id] = tokenSupply[_id]+_quantity;
    }
}

