# Solidity API

## Reward

### name

```solidity
string name
```

### symbol

```solidity
string symbol
```

### tokenSupply

```solidity
mapping(uint256 => uint256) tokenSupply
```

mapping between token id and total token supply

### tokenReserve

```solidity
mapping(uint256 => uint256) tokenReserve
```

mapping between token id and total token reserved for given token id

### creators

```solidity
mapping(uint256 => address) creators
```

mapping between token id and the address of the token

### admin

```solidity
mapping(address => bool) admin
```

add given address as a admin

### constructor

```solidity
constructor(string _name, string _symbol, string _uri) public
```

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _name | string | name of the contracts |
| _symbol | string | symbol of the contracts |
| _uri | string | base uri for the given nfts |

### onlyAdmin

```solidity
modifier onlyAdmin()
```

modifier to check the admin role of the address

### createToken

```solidity
function createToken(uint256 _initialSupply, uint256 _tokenReserve) public returns (uint256 _id)
```

function to create new token

_only admin can create the token_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _initialSupply | uint256 | initial supply of the token |
| _tokenReserve | uint256 | total mintable quantity for token |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| _id | uint256 | id of token created |

### mintToken

```solidity
function mintToken(address _to, uint256 _id, uint256 _quantity) public
```

function to mint token

_can be called by any one_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _to | address | address to mint the given token id |
| _id | uint256 | token id to mint |
| _quantity | uint256 | total amount of token to be minted |

### batchMint

```solidity
function batchMint(address _to, uint256[] _ids, uint256[] _quantity) public
```

function to mint batch token

_can be called by any one_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _to | address | address to mint the given token id |
| _ids | uint256[] | token ids to mint |
| _quantity | uint256[] | total amount of token to be minted |

### _exists

```solidity
function _exists(uint256 _id) internal view returns (bool exist)
```

internal function to check the existence of the token

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _id | uint256 | id to check existence |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| exist | bool | boolean value of existence |

### pause

```solidity
function pause() public
```

function to pause the minting feature

_only admin can call the function_

### unpause

```solidity
function unpause() public
```

function to unpause the minting feature

_only admin can call the function_

