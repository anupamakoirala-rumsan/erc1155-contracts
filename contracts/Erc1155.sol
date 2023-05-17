// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.10;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/security/Pausable.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/utils/math/Math.sol';

contract Reward is ERC1155, Pausable{
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

    function createToken(uint256 _initialSupply, uint256 _tokenReserve) public onlyAdmin returns(uint256) {
        uint256 _id = _currentTokenId.current();
        creators[_id] = msg.sender;
        tokenSupply[_id] = _initialSupply;
        tokenReserve[_id] = _tokenReserve;
        _currentTokenId.increment();
        _mint(msg.sender, _id, _initialSupply,'');
        return _id;
    }

    function mintToken(address _to ,uint256 _id, uint256 _quantity) public whenNotPaused{
        require(_exists(_id),"Token doesnot exists");
        require(tokenReserve[_id]>tokenSupply[_id] + _quantity,"Token limit hit");
        tokenSupply[_id] = tokenSupply[_id]+_quantity;
        _mint(_to, _id, _quantity, '');
    }

    function batchMint(address _to, uint256[] memory _ids, uint256[] memory _quantity) public whenNotPaused {
        for(uint256 i =0; i< _ids.length; i++)
        {   
            require(_exists(i),"Token doesnot exists");
            require(tokenReserve[i] > tokenSupply[i] + _quantity[i],"Token limited");
            tokenSupply[i] = tokenSupply[i] + _quantity[i];
        }
        _mintBatch(_to, _ids, _quantity, '');
    }

    function _exists(uint256 _id) internal view returns(bool){
        return creators[_id] != address(0);
    }

    function pause() public onlyAdmin{
        _pause();
    }

    function unpause() public whenPaused onlyAdmin{
        _unpause();
    }
}

