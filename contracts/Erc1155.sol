// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.10;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/security/Pausable.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/utils/math/Math.sol';

contract Reward is ERC1155, Pausable {
     
    using Counters for Counters.Counter;
    using Math for uint256;

    Counters.Counter private _currentTokenId;

    string public name;
    string public symbol;

    ///@notice mapping between token id and total token supply
    mapping(uint256=>uint256) public tokenSupply;
    
    ///@notice mapping between token id and total token reserved for given token id
    mapping(uint256=>uint256) public tokenReserve;

    ///@notice mapping between token id and the address of the token
    mapping(uint256 => address) public creators;

    ///@notice add given address as a admin
    mapping(address=>bool) public admin;

    ///@param _name name of the contracts
    ///@param _symbol symbol of the contracts
    ///@param _uri base uri for the given nfts
    constructor(string memory _name, string memory _symbol, string memory _uri) ERC1155(_uri){
        name = _name;
        symbol = _symbol;
        admin[msg.sender] = true;
        _setURI(_uri);
    }

    ///@notice modifier to check the admin role of the address
    modifier onlyAdmin(){
        require(admin[msg.sender],"Not admin");
        _;
    }

    ///@notice function to create new token 
    ///@param _initialSupply initial supply of the token
    ///@param _tokenReserve total mintable quantity for token
    ///@return _id id of token created
    ///@dev only admin can create the token
    function createToken(uint256 _initialSupply, uint256 _tokenReserve) public onlyAdmin returns(uint256 _id) {
         _id = _currentTokenId.current();
        creators[_id] = msg.sender;
        tokenSupply[_id] = _initialSupply;
        tokenReserve[_id] = _tokenReserve;
        _currentTokenId.increment();
        _mint(msg.sender, _id, _initialSupply,'');
        return _id;
    }

    ///@notice function to mint token
    ///@param _to address to mint the given token id
    ///@param _id token id to mint
    ///@param _quantity total amount of token to be minted
    ///@dev can be called by any one 
    function mintToken(address _to ,uint256 _id, uint256 _quantity) public whenNotPaused{
        require(_exists(_id),"Token doesnot exists");
        require(tokenReserve[_id]>tokenSupply[_id] + _quantity,"Token limit hit");
        tokenSupply[_id] = tokenSupply[_id]+_quantity;
        _mint(_to, _id, _quantity, '');
    }

    ///@notice function to mint batch token
    ///@param _to address to mint the given token id
    ///@param _ids token ids to mint
    ///@param _quantity total amount of token to be minted
    ///@dev can be called by any one
    function batchMint(address _to, uint256[] memory _ids, uint256[] memory _quantity) public whenNotPaused {
        for(uint256 i =0; i< _ids.length; i++)
        {   
            require(_exists(i),"Token doesnot exists");
            require(tokenReserve[i] > tokenSupply[i] + _quantity[i],"Token limited");
            tokenSupply[i] = tokenSupply[i] + _quantity[i];
        }
        _mintBatch(_to, _ids, _quantity, '');
    }

    ///@notice internal function to check the existence of the token
    ///@param _id id to check existence
    ///@return exist boolean value of existence
    function _exists(uint256 _id) internal view returns(bool exist){
        return creators[_id] != address(0);
    }

    ///@notice function to pause the minting feature
    ///@dev only admin can call the function
    function pause() public onlyAdmin{
        _pause();
    }

    ///@notice function to unpause the minting feature
    ///@dev only admin can call the function
    function unpause() public whenPaused onlyAdmin{
        _unpause();
    }
}

